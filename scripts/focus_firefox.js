var appName = "firefox";

// Search for a Firefox window
var client = workspace.clientList().find(c => c.resourceName === appName);

if (client) {
    // Focus the window
    workspace.activeClient = client;
} else {
    // Start Firefox if not running
    workspace.launch("firefox");
}

