//+build darwin

package platform

import "log"
import "net"

func GetDestAddrFromConn(conn net.Conn) string {
	log.Println("platform not support route method")
	return ""
}

func KillPid(pid int) {
	syscall.Kill(pid, syscall.SIGTERM)
}
