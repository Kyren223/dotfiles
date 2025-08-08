package main

import (
	"bufio"
	"crypto/ed25519"
	"encoding/base64"
	"encoding/pem"
	"fmt"
	"os"
	"os/exec"
	"strings"

	"golang.org/x/crypto/ssh"
)

func main() {
	key := ""

	fmt.Println("Key:")
	_, _ = fmt.Scan(&key)

	reader := bufio.NewReader(os.Stdin)
	fmt.Print("Passphrase: ")
	passphrase, _ := reader.ReadString('\n')
	passphrase = strings.TrimSpace(passphrase)

	keyBytes, err := base64.StdEncoding.DecodeString(key)
	if err != nil {
		fmt.Println("Invalid base64:", err)
		return
	}
	if len(keyBytes) != 64 {
		fmt.Println("Invalid key length:", len(keyBytes))
		return
	}

	// Use the first 32 bytes as private seed
	privKey := ed25519.NewKeyFromSeed(keyBytes[:32])

	var pemBlock *pem.Block
	hasPassphrase := passphrase != "none"
	if hasPassphrase {
		fmt.Printf("Encrypting with passphrase: '%s'\n", passphrase)
		pemBlock, err = ssh.MarshalPrivateKeyWithPassphrase(privKey, "eko", []byte(passphrase))
	} else {
		fmt.Println("Encrypting without passphrase")
		pemBlock, err = ssh.MarshalPrivateKey(privKey, "eko")
	}

	if err != nil {
		fmt.Println("failed private key marshaling", err)
		return
	}
	err = pem.Encode(os.Stdout, pemBlock)
	if err != nil {
		fmt.Println("pem encoding to file error:", err)
		return
	}

	fmt.Println("randomart")
	printRandomart(privKey)
}

func printRandomart(key ed25519.PrivateKey) {
	pub, err := ssh.NewPublicKey(key.Public())
	if err != nil {
		panic(err)
	}

	tmpfile, err := os.CreateTemp("", "id_ed25519.pub")
	if err != nil {
		panic(err)
	}
	defer os.Remove(tmpfile.Name())

	tmpfile.Write(ssh.MarshalAuthorizedKey(pub))
	tmpfile.Close()

	cmd := exec.Command("ssh-keygen", "-lvf", tmpfile.Name())
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	cmd.Run()
}
