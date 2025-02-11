NLEG = 4
legCS1 = 0
legLS1 = 1
legLS2 = 2
legMG1 = 3
legnames = (/     "CS1",    "LS1" , "LS2", "MG1"/)
legnstas  = (/       24,      25,      25,    31/) ; LS2 modified in November

NZ = 1000

KZS = (/2,10,40,50,60/)
NKZ = dimsizes(KZS)

NVAR = 5
varZ = 0
varT = 1
varS = 2
varD = 3
varB = 4
varfiles = (/"Z","T","S","D","BV"/)
varnames = (/"Depth","Temperature","Salinity","Density","Brunt-Vaisala"/)
varunits = (/"m","~S~o~N~C","PSU","kg m-3","cycles per hour"/)

NSTA = 32

NMODEL = 3
modelfiles = new(NMODEL,string)
modelINSITU = 0
modelfiles(modelINSITU) = "INSITU"
modelMFS_SYS4E = 1
modelfiles(modelMFS_SYS4E) = "SYS4E"
modelMFS_SYS4E_MREA14 = 2
modelfiles(modelMFS_SYS4E_MREA14) = "SYS4E-MREA14"

