package main

import (
	"os"

	"github.com/hyv5/go-nas/cmd/server/cmd"
	"github.com/urfave/cli/v2"
)

// Usage: go build -ldflags "-X main.VERSION=x.x.x"
var VERSION = "v10.1.0"

// @title go-nas
// @version v10.1.0
// @description A simple NAS server design for old android phone
// @securityDefinitions.apikey ApiKeyAuth
// @in header
// @name Authorization
// @schemes http https
// @basePath /
func main() {
	app := cli.NewApp()
	app.Name = "go-nas"
	app.Version = VERSION
	app.Usage = "A simple NAS server design for old android phone"
	app.Commands = []*cli.Command{
		cmd.StartCmd(),
		cmd.StopCmd(),
		cmd.VersionCmd(VERSION),
	}
	err := app.Run(os.Args)
	if err != nil {
		panic(err)
	}
}
