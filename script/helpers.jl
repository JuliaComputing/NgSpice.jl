# Found necessary now, might delete later

const sc = Ptr{Ngspice.SendChar} 
const ss = Ptr{Ngspice.SendStat}
const ce = Ptr{Ngspice.ControlledExit}
const sd = Ptr{Ngspice.SendData}
const sid =Ptr{Ngspice.SendInitData}
const bgt =Ptr{Ngspice.BGThreadRunning}
const v =  Ptr{Cvoid}

fpgen(a, fp) = (a=a; convert(Ptr{fp}, a))
