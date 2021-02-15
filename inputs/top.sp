.title Ring Ladder
.include '/1N4148.lib'
.subckt ring_ladder i0 q0 r0 r5
.subckt diode_bridge n1 n2 n3 n4
XD1 n1 n2 1N4148
XD2 n2 n3 1N4148
XD3 n4 n3 1N4148
XD4 n1 n4 1N4148
.ends diode_bridge
XDR1 r0 i1 r1 q1 diode_bridge
CCi1 i0 i1 10pF
CCq1 q0 q1 10pF
CCr1 r0 r1 100pF
RRid1 i1 r0 100GOhm
RRqd1 q1 r0 100GOhm
RRrd1 r1 r0 100GOhm
XDR2 r1 i2 r2 q2 diode_bridge
CCi2 i1 i2 10pF
CCq2 q1 q2 10pF
CCr2 r1 r2 100pF
RRid2 i2 r0 100GOhm
RRqd2 q2 r0 100GOhm
RRrd2 r2 r0 100GOhm
XDR3 r2 i3 r3 q3 diode_bridge
CCi3 i2 i3 10pF
CCq3 q2 q3 10pF
CCr3 r2 r3 100pF
RRid3 i3 r0 100GOhm
RRqd3 q3 r0 100GOhm
RRrd3 r3 r0 100GOhm
XDR4 r3 i4 r4 q4 diode_bridge
CCi4 i3 i4 10pF
CCq4 q3 q4 10pF
CCr4 r3 r4 100pF
RRid4 i4 r0 100GOhm
RRqd4 q4 r0 100GOhm
RRrd4 r4 r0 100GOhm
XDR5 r4 i5 r5 q5 diode_bridge
CCi5 i4 i5 10pF
CCq5 q4 q5 10pF
CCr5 r4 r5 100pF
RRid5 i5 r0 100GOhm
RRqd5 q5 r0 100GOhm
RRrd5 r5 r0 100GOhm
.ends ring_ladder
Vinput input 0 dc 0 sin(0 'amp' 'freq')
E2 input_q 0 input 0 -1
Rinput input i 0.0001Ohm
Rinput_q input_q q 0.0001Ohm
X1 i q 0 output ring_ladder
Rdummy output 0 1GOhm
.param amp=10V freq=5MegHz period='1/freq'
.param tstep='period/200' tstop='period*20'
.tran 'tstep' 'tstop'
.option temp=25
.print tran v(input) v(output)
.control
run 
plot v(input) v(output)
.endc
.end