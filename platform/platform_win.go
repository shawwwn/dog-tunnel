//+build windows

package platform

import "log"
import "net"
import "os/exec"
import "strconv"

func GetDestAddrFromConn(conn net.Conn) string {
	log.Println("platform not support route method")
	return ""
}

func KillPid(pid int) {
	exec.Command("taskkill", "/PID", strconv.Itoa(pid))
}
