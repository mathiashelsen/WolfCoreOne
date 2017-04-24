package main

import (
	"bufio"
	"fmt"
	"io"
	"log"
	"strconv"
	"strings"

	"../../ihex"
	"../../isa"
)

const (
	COMMENT = "//"
	DEREF   = "*"
)

func Assemble(in io.Reader, out, vhdout io.Writer) {
	reader := bufio.NewReader(in)
	var pc uint16
	for words, ok := ParseLine(reader); ok; words, ok = ParseLine(reader) {
		if len(words) == 0 {
			continue
		}

		if strings.HasPrefix(words[0], "#") {
			continue
		}
		if pc == 0 {
			fmt.Println("i aaaa bbbb iiiiiii ppp ooooo cccc www c")
		}

		var bits uint32

		if words[0] == "DATA" {
			v := ParseInt(words[1], 32)
			bits = uint32(v)
		} else {
			// final cmp bit is optional, default: -cmp
			if len(words) == 5 {
				words = append(words, "-cmp")
			}
			if len(words) != 6 {
				Err("need 5 operands")
			}
			opc := ParseOpcode(words[0])
			ra, ptra := ParseReg(transl(words[1]))
			immb, rb, imml, ptrb := ParseBVal(transl(words[2]))
			cond := ParseCond(words[3])
			rc, ptrc := ParseReg(transl(words[4]))
			comp := ParseCmp(words[5])

			ptr := (ptra << 0) | (ptrb << 1) | (ptrc << 2)

			bits = isa.SetBits(bits, isa.IB, isa.IB, immb)
			bits = isa.SetBits(bits, isa.RAl, isa.RAh, ra)
			bits = isa.SetBits(bits, isa.RBl, isa.RBh, rb)
			bits = isa.SetBits(bits, isa.ILl, isa.ILh, imml)
			bits = isa.SetBits(bits, isa.PTl, isa.PTh, ptr)
			bits = isa.SetBits(bits, isa.OPl, isa.OPh, opc)
			bits = isa.SetBits(bits, isa.RCl, isa.RCh, rc)
			bits = isa.SetBits(bits, isa.WCl, isa.WCh, cond)
			bits = isa.SetBits(bits, isa.CMP, isa.CMP, comp)
		}
		fmt.Fprintf(vhdout, "-- %s\n", words)
		fmt.Fprintf(vhdout, "when X\"%08x\" =>\n", pc)
		fmt.Fprintf(vhdout, "\t instrOutput <= X\"%08x\";\n", bits)
		ihex.WriteUint32(out, pc, bits)

		Print(bits, words)

		pc++
	}
	ihex.WriteEOF(out)
}

func Print(bits uint32, words []string) {
	fmt.Printf("%01b ", isa.GetBits(bits, isa.IB, isa.IB))
	fmt.Printf("%04b ", isa.GetBits(bits, isa.RAl, isa.RAh))
	fmt.Printf("%04b ", isa.GetBits(bits, isa.RBl, isa.RBh))
	fmt.Printf("%07b ", isa.GetBits(bits, isa.ILl, isa.ILh))
	fmt.Printf("%03b ", isa.GetBits(bits, isa.PTl, isa.PTh))
	fmt.Printf("%05b ", isa.GetBits(bits, isa.OPl, isa.OPh))
	fmt.Printf("%04b ", isa.GetBits(bits, isa.RCl, isa.RCh))
	fmt.Printf("%03b ", isa.GetBits(bits, isa.WCl, isa.WCh))
	fmt.Printf("%01b ", isa.GetBits(bits, isa.CMP, isa.CMP))

	for _, w := range words {
		fmt.Print(w, " ")
	}
	fmt.Println()
}

func ParseOpcode(x string) uint32 {
	if op, ok := isa.Opcodes[x]; ok {
		return op
	} else {
		Err("illegal instruction: ", x)
		panic("")
	}
}

func ParseCond(x string) uint32 {
	if c, ok := isa.Condcodes[x]; ok {
		return c
	} else {
		Err("illegal condition: ", x)
		panic("")
	}
}

func ParseReg(x string) (reg uint32, ptr uint32) {
	if x == "PC" {
		return isa.PCREG, 0
	}
	if x == "Rx" {
		return isa.OVERFLOWREG, 0
	}

	if strings.HasPrefix(x, DEREF) {
		ptr = 1
		x = x[1:]
	}
	r := transl(x)
	if !strings.HasPrefix(r, "R") {
		Err("expected register, got: ", r)
	}
	r = r[1:]
	rN, err := strconv.Atoi(r)
	if err != nil {
		Err("malformed register name: R", r)
	}
	if rN == isa.PCREG {
		Err("the program counter is explicitly called PC")
	}
	if rN == isa.OVERFLOWREG {
		Err("the overflow register is explicitly called Rx")
	}
	if rN > isa.MAXREG || rN < 0 {
		Err("no such register: R", r)
	}
	return uint32(rN), ptr
}

func ParseBVal(x string) (immb, regb, immv, ptr uint32) {
	if strings.HasPrefix(x, "R") || strings.HasPrefix(x, DEREF+"R") {
		r, p := ParseReg(x)
		return 0, r, 0, p
	} else {
		immv := ParseInt(x, 11)
		regb := (immv >> 7) & 0xF
		imml := (immv & 0x007F)
		assert(regb < isa.NREG)
		return 1, regb, imml, 0
	}
}

func ParseCmp(x string) uint32 {
	switch x {
	default:
		Err("illegal condition: ", x, " (need +cmp or -cmp)")
		panic("")
	case "+cmp":
		return 1
	case "-cmp":
		return 0
	}
}

func ParseInt(x string, bits uint8) uint32 {
	v, err := isa.ParseInt(x, bits)
	if err != nil {
		Err(err)
	}
	return v
}

//func Addr(words []string) uint16 {
//	a := transl(words[2])
//	addr, err := strconv.ParseInt(a, 0, 32)
//	if err != nil {
//		Err("malformed number:", a, err)
//	}
//	if addr > MAXINT {
//		Err("too big:", a)
//	}
//	return uint16(addr)
//}

func Err(msg ...interface{}) {
	str := fmt.Sprint(msg...)
	log.Fatal(filename, ": ", linenumber, ": ", str)
}

func assert(test bool) {
	if !test {
		panic("assertion failed")
	}
}

func ParseLine(in *bufio.Reader) ([]string, bool) {
	linenumber++
	line, err := in.ReadString('\n')
	if err == io.EOF {
		return nil, false
	}
	if err != nil {
		log.Fatal(err)
	}
	line = strings.Replace(line, "\t", " ", -1)
	words := strings.Split(line, " ")
	tokens := make([]string, 0, 3)
	for _, w := range words {
		if strings.HasPrefix(w, COMMENT) {
			break
		}
		w = strings.Trim(w, "\n")
		if w != "" {
			tokens = append(tokens, w)
		}
	}
	return tokens, true
}
