// package isa defines the instruction set
package isa

import (
//"fmt"
)

// Machine properties
const (
	INSTR_WORDS  = 1 << 12    // available number of instruction words
	MEM_WORDS    = 1 << 12    // available number of data words
	NREG         = 16         // number of registers
	MAXREG       = NREG - 1   // highest register for RA, RC
	MAXREGB      = MAXREG - 2 // highest register for RB
	PCREG        = 14         // register holding program counter
	OVERFLOWREG  = 20         // register holding overflow of mul, div
	PERI_DISPLAY = 0x3FFF     // memory-mapped address of 7-segment display
)

// Instruction layout:
//  31  30 29 28 27 26 25 24 23 22 21 20 19 18 17 16 15 14 13
//  IB  ----RA----- -----RB---- ------IL------------ ---PT---
//
//  12  11 10  9  8  7  6  5  4  3  2  1  0
//   -----OPC------  ---RC-----  -Cond--  cmp
const (
	IB  = 31 // 0: put RB on BValue bus, 1: put bits [26:13] on BValue bus
	RAh = 30 // register A
	RAl = 27 // register A
	RBh = 26 // register B, or 4 MSB's of immediate value when ImmB=1
	RBl = 23 // register B, or 4 MSB's of immediate value when ImmB=1
	ILh = 22 // 7 bits immediate value
	ILl = 16 // 7 bits immediate value
	PTh = 15 // dereference registers?
	PTl = 13 // dereference registers?
	OPh = 12 // Opcode selector for ALU/Memory
	OPl = 8  // Opcode selector for ALU/Memory
	RCh = 7  // register C
	RCl = 4  // register C
	WCh = 3  // Writeback condition
	WCl = 1  // Writeback condition
	CMP = 0  // 1: Update status register
)

// Values for Writeback condition (µI bits 3:1)
// Writeback condition determines whether the ALU result
// gets written back to register RC, based on status register
// holding the result of a previous comparison to zero.
const (
	NEVER  = 0 // don't write back
	ALWAYS = 1 // write Cbus back to RC
	ZERO   = 2 // write back if last compare was zero
	NZ     = 3 // write back if last compare was nonzero
	GE     = 4 // write back if last compare was >= 0
	LT     = 5 // write back if last compare was < 0
	OF     = 6 // write back on overflow
	NOF    = 7 // write back on not overflow
)

// ALU Opcodes
const (
	NOP   = 0x00
	LOAD  = 0x01 //  C <= mem[Ra+BBus]
	STORE = 0x02 //  mem[B] = Ra, C <= Ra-1
	AND   = 0x03 //  C <= Ra & B
	OR    = 0x04 //  C <= Ra | Rb
	XOR   = 0x05 //  C <= Ra ^ Rb
	ADD   = 0x06 //  C <= Ra + Rb
	SUB   = 0x07 //  C <= Ra - Rb, unsigned
	SUBS  = 0x08 //  C <= Ra - Rb, signed
	MOV   = 0x09
	BSL   = 0x0A
	BSR   = 0x0B
        NOT   = 0x0C
)

// Human-readable strings for Conditions
var CondStr = map[uint32]string{
	ALWAYS: "A",
	NEVER:  "N",
	ZERO:   "Z",
	NZ:     "NZ",
	GE:     "GE",
	LT:     "LT",
	OF:     "OF",
	NOF:    "NOF",
}

// Human-readable strings for Opcodes
var OpcodeStr = map[uint32]string{
	NOP:   "NOP",
	LOAD:  "LOAD",
	STORE: "STORE",
	AND:   "AND",
	OR:    "OR",
	XOR:   "XOR",
	ADD:   "ADD",
	SUB:   "SUB",
	SUBS:  "SUBS",
	MOV:   "MOV",
	BSL:   "BSL",
	BSR:   "BSR",
        NOT:    "NOT",
}

// Parses opcodes
var Opcodes map[string]uint32

// Parses conditions
var Condcodes map[string]uint32

func init() {
	Opcodes = invert(OpcodeStr)
	Condcodes = invert(CondStr)
}

func invert(m map[uint32]string) map[string]uint32 {
	inv := make(map[string]uint32)
	for k, v := range m {
		inv[v] = k
	}
	return inv
}
