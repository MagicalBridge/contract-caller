package main

import (
	"context"
	"os"

	"github.com/ethereum/go-ethereum/log"

	"github.com/MagicalBridge/contract-caller/common/opio"
)

var (
	GitCommit = ""
	GitData   = ""
)

func main() {
	// set up logging
	log.SetDefault(log.NewLogger(log.NewTerminalHandlerWithLevel(os.Stderr, log.LevelInfo, true)))
	// create the cli app
	app := NewCli(GitCommit, GitData)
	// create a context with interrupt blocker
	ctx := opio.WithInterruptBlocker(context.Background())
	// run the cli app
	if err := app.RunContext(ctx, os.Args); err != nil {
		log.Error("Application failed", "error", err)
		os.Exit(1)
	}
}
