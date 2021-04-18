using NgSpice
using Test

NgSpice.init()

nl = """
* Diode test circuit
V1 inp 0 DC=1 AC=1 SIN(1 1 1000)
* Connected in forward bias:
D1 inp 0 dmod
.model dmod d cjo=0 m=1 rs=5000 area=1 pj=0 cjp=0 mj=0 mjsw=0 pb=1 php=1 n=2 bv=0 ibv=0 ik=0 ikr=0 is=1.0e-9 tt=0
.save all @d1[id] @d1[cd] @d1[charge] @d1[vd]
.END
"""

@test NgSpice.load_netlist(nl) == 0
