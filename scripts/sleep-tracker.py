#!/usr/bin/env python
import matplotlib.pyplot as plt
import pandas as pd
import argparse
from datetime import datetime

# Hardcoded file path
FILE_PATH = "/home/kyren/personal/dairy/sleep-tracker.md"

def parse_time(value, is_evening=False):
    if value == "N/A" or value == "Morning" or value == "Evening":
        return None
    time = datetime.strptime(value, "%I:%M %p")
    hour = time.hour + time.minute / 60
    if is_evening and time.hour < 12:
        hour += 24
    return hour

def format_time(value):
    if pd.isna(value):
        return "N/A"
    hour = int(value) % 24
    minute = int((value - int(value)) * 60)
    period = "AM" if hour < 12 else "PM"
    hour = hour if hour <= 12 else hour - 12
    hour = 12 if hour == 0 else hour
    return f"{hour}:{minute:02d} {period}"

def read_data(file_path):
    with open(file_path, 'r') as f:
        lines = f.readlines()[4:]  # Skip the first four lines

    data = []

    for line in lines:
        parts = [part.strip() for part in line.strip().split('|') if part.strip()]
        if len(parts) == 3 and parts[0] != "Date":
            date, morning, evening = parts
            data_point = [
                date, 
                parse_time(morning), 
                parse_time(evening, is_evening=True)
            ]
            data.append(data_point)

    df = pd.DataFrame(data, columns=['Date', 'Morning', 'Evening'])
    df['Date'] = pd.to_datetime(df['Date'], format='%Y-%m-%d', errors='coerce')
    return df.dropna(subset=['Date'])

def filter_data(data, start_date, end_date):
    mask = (data['Date'] >= start_date) & (data['Date'] <= end_date)
    return data[mask]

def plot_graph(data):
    plt.style.use('dark_background')
    plt.figure(figsize=(10, 6))
    plt.plot(data['Date'], data['Morning'], 'r-o', label='Morning')
    plt.plot(data['Date'], data['Evening'], 'b-o', label='Evening')
    plt.title(f'Time Graph from {data["Date"].min().date()} to {data["Date"].max().date()}')
    plt.xlabel('Date')
    plt.ylabel('Time (Hours)')
    plt.xticks(rotation=0)
    plt.grid(True, linestyle='--', alpha=0.6)
    plt.legend()
    plt.show()

def print_statistics(data):
    for period in ['Morning', 'Evening']:
        times = data[period].dropna()
        if not times.empty:
            print(f"{period}: Min={format_time(times.min())}, Max={format_time(times.max())}, Avg={format_time(times.mean())}, Median={format_time(times.median())}")
        else:
            print(f"{period}: No data available")

def main():
    parser = argparse.ArgumentParser(description="Plot time graph from a data file.")
    parser.add_argument('--from', dest='start_date', type=str, help='Start date (yyyy-mm-dd)')
    parser.add_argument('--to', dest='end_date', type=str, help='End date (yyyy-mm-dd)')
    args = parser.parse_args()

    data = read_data(FILE_PATH)

    start_date = pd.to_datetime(args.start_date, format='%Y-%m-%d', errors='coerce') if args.start_date else data['Date'].min()
    end_date = pd.to_datetime(args.end_date, format='%Y-%m-%d', errors='coerce') if args.end_date else data['Date'].max()

    filtered_data = filter_data(data, start_date, end_date)

    if filtered_data.empty:
        print("No data available for the specified date range.")
        return

    print_statistics(filtered_data)
    plot_graph(filtered_data)

if __name__ == '__main__':
    main()
