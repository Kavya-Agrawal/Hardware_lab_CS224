# File saved with Nlview 7.8.0 2024-04-26 e1825d835c VDI=44 GEI=38 GUI=JA:21.0 threadsafe
# 
# non-default properties - (restore without -noprops)
property -colorscheme classic
property attrcolor #000000
property attrfontsize 8
property autobundle 1
property backgroundcolor #ffffff
property boxcolor0 #000000
property boxcolor1 #000000
property boxcolor2 #000000
property boxinstcolor #000000
property boxpincolor #000000
property buscolor #008000
property closeenough 5
property createnetattrdsp 2048
property decorate 1
property elidetext 40
property fillcolor1 #ffffcc
property fillcolor2 #dfebf8
property fillcolor3 #f0f0f0
property gatecellname 2
property instattrmax 30
property instdrag 15
property instorder 1
property marksize 12
property maxfontsize 18
property maxzoom 7.5
property netcolor #19b400
property objecthighlight0 #ff00ff
property objecthighlight1 #ffff00
property objecthighlight2 #00ff00
property objecthighlight3 #0095ff
property objecthighlight4 #8000ff
property objecthighlight5 #ffc800
property objecthighlight7 #00ffff
property objecthighlight8 #ff00ff
property objecthighlight9 #ccccff
property objecthighlight10 #0ead00
property objecthighlight11 #cefc00
property objecthighlight12 #9e2dbe
property objecthighlight13 #ba6a29
property objecthighlight14 #fc0188
property objecthighlight15 #02f990
property objecthighlight16 #f1b0fb
property objecthighlight17 #fec004
property objecthighlight18 #149bff
property objecthighlight19 #eb591b
property overlaycolor #19b400
property pbuscolor #000000
property pbusnamecolor #000000
property pinattrmax 20
property pinorder 2
property pinpermute 0
property portcolor #000000
property portnamecolor #000000
property ripindexfontsize 4
property rippercolor #000000
property rubberbandcolor #000000
property rubberbandfontsize 18
property selectattr 0
property selectionappearance 2
property selectioncolor #0000ff
property sheetheight 44
property sheetwidth 68
property showmarks 1
property shownetname 0
property showpagenumbers 1
property showripindex 1
property timelimit 1
#
module new top_MIPS work:top_MIPS:NOFILE -nosplit
load symbol alu_control work:alu_control:NOFILE HIERBOX pinBus ALUOp input.left [1:0] pinBus ALU_opcode output.right [3:0] pinBus funct input.left [5:0] boxcolor 1 fillcolor 2 minwidth 13%
load symbol controller work:controller:NOFILE HIERBOX pin ALUSrc output.right pin Branch output.right pin JR output.right pin Jump output.right pin Link output.right pin MemRead output.right pin MemToReg output.right pin MemWrite output.right pin PC_en output.right pin RegDst output.right pin RegWrite output.right pin clk input.left pin reset input.left pinBus ALUOp output.right [1:0] pinBus OpCode input.left [5:0] boxcolor 1 fillcolor 2 minwidth 13%
load symbol MIPS_datapath work:MIPS_datapath:NOFILE HIERBOX pin ALUSrc input.left pin Branch input.left pin JR input.left pin Jump input.left pin Link input.left pin MemRead input.left pin MemToReg input.left pin MemWrite input.left pin PC_en input.left pin RegDst input.left pin RegWrite input.left pin clk input.left pin reset input.left pinBus ALU_opcode input.left [3:0] pinBus OpCode output.right [5:0] pinBus funct output.right [5:0] boxcolor 1 fillcolor 2 minwidth 13%
load port clk input -pg 1 -lvl 0 -x 0 -y 330
load port reset input -pg 1 -lvl 0 -x 0 -y 360
load inst alu_ctrl alu_control work:alu_control:NOFILE -autohide -attr @cell(#000000) alu_control -pinBusAttr ALUOp @name ALUOp[1:0] -pinBusAttr ALU_opcode @name ALU_opcode[3:0] -pinBusAttr funct @name funct[5:0] -pg 1 -lvl 3 -x 1110 -y 580
load inst ctrl controller work:controller:NOFILE -autohide -attr @cell(#000000) controller -pinBusAttr ALUOp @name ALUOp[1:0] -pinBusAttr OpCode @name OpCode[5:0] -pg 1 -lvl 2 -x 670 -y 160
load inst datapath MIPS_datapath work:MIPS_datapath:NOFILE -autohide -attr @cell(#000000) MIPS_datapath -pinBusAttr ALU_opcode @name ALU_opcode[3:0] -pinBusAttr OpCode @name OpCode[5:0] -pinBusAttr funct @name funct[5:0] -pg 1 -lvl 1 -x 370 -y 80
load net ALUOp[0] -attr @rip ALUOp[0] -pin alu_ctrl ALUOp[0] -pin ctrl ALUOp[0]
load net ALUOp[1] -attr @rip ALUOp[1] -pin alu_ctrl ALUOp[1] -pin ctrl ALUOp[1]
load net ALUSrc -pin ctrl ALUSrc -pin datapath ALUSrc
netloc ALUSrc 1 0 3 60 10 NJ 10 990
load net ALU_opcode[0] -attr @rip ALU_opcode[0] -pin alu_ctrl ALU_opcode[0] -pin datapath ALU_opcode[0]
load net ALU_opcode[1] -attr @rip ALU_opcode[1] -pin alu_ctrl ALU_opcode[1] -pin datapath ALU_opcode[1]
load net ALU_opcode[2] -attr @rip ALU_opcode[2] -pin alu_ctrl ALU_opcode[2] -pin datapath ALU_opcode[2]
load net ALU_opcode[3] -attr @rip ALU_opcode[3] -pin alu_ctrl ALU_opcode[3] -pin datapath ALU_opcode[3]
load net Branch -pin ctrl Branch -pin datapath Branch
netloc Branch 1 0 3 240 30 NJ 30 830
load net JR -pin ctrl JR -pin datapath JR
netloc JR 1 0 3 120 470 NJ 470 990
load net Jump -pin ctrl Jump -pin datapath Jump
netloc Jump 1 0 3 200 430 NJ 430 870
load net Link -pin ctrl Link -pin datapath Link
netloc Link 1 0 3 240 450 NJ 450 830
load net MemRead -pin ctrl MemRead -pin datapath MemRead
netloc MemRead 1 0 3 80 490 NJ 490 970
load net MemToReg -pin ctrl MemToReg -pin datapath MemToReg
netloc MemToReg 1 0 3 100 510 NJ 510 950
load net MemWrite -pin ctrl MemWrite -pin datapath MemWrite
netloc MemWrite 1 0 3 140 530 NJ 530 930
load net OpCode[0] -attr @rip OpCode[0] -pin ctrl OpCode[0] -pin datapath OpCode[0]
load net OpCode[1] -attr @rip OpCode[1] -pin ctrl OpCode[1] -pin datapath OpCode[1]
load net OpCode[2] -attr @rip OpCode[2] -pin ctrl OpCode[2] -pin datapath OpCode[2]
load net OpCode[3] -attr @rip OpCode[3] -pin ctrl OpCode[3] -pin datapath OpCode[3]
load net OpCode[4] -attr @rip OpCode[4] -pin ctrl OpCode[4] -pin datapath OpCode[4]
load net OpCode[5] -attr @rip OpCode[5] -pin ctrl OpCode[5] -pin datapath OpCode[5]
load net PC_en -pin ctrl PC_en -pin datapath PC_en
netloc PC_en 1 0 3 160 550 NJ 550 910
load net RegDst -pin ctrl RegDst -pin datapath RegDst
netloc RegDst 1 0 3 180 570 NJ 570 890
load net RegWrite -pin ctrl RegWrite -pin datapath RegWrite
netloc RegWrite 1 0 3 220 590 NJ 590 850
load net clk -port clk -pin ctrl clk -pin datapath clk
netloc clk 1 0 2 20 390 550J
load net funct[0] -attr @rip funct[0] -pin alu_ctrl funct[0] -pin datapath funct[0]
load net funct[1] -attr @rip funct[1] -pin alu_ctrl funct[1] -pin datapath funct[1]
load net funct[2] -attr @rip funct[2] -pin alu_ctrl funct[2] -pin datapath funct[2]
load net funct[3] -attr @rip funct[3] -pin alu_ctrl funct[3] -pin datapath funct[3]
load net funct[4] -attr @rip funct[4] -pin alu_ctrl funct[4] -pin datapath funct[4]
load net funct[5] -attr @rip funct[5] -pin alu_ctrl funct[5] -pin datapath funct[5]
load net reset -pin ctrl reset -pin datapath reset -port reset
netloc reset 1 0 2 40 410 570J
load netBundle @ALU_opcode 4 ALU_opcode[3] ALU_opcode[2] ALU_opcode[1] ALU_opcode[0] -autobundled
netbloc @ALU_opcode 1 0 4 60 650 NJ 650 NJ 650 1300
load netBundle @ALUOp 2 ALUOp[1] ALUOp[0] -autobundled
netbloc @ALUOp 1 2 1 1010 170n
load netBundle @OpCode 6 OpCode[5] OpCode[4] OpCode[3] OpCode[2] OpCode[1] OpCode[0] -autobundled
netbloc @OpCode 1 1 1 570 210n
load netBundle @funct 6 funct[5] funct[4] funct[3] funct[2] funct[1] funct[0] -autobundled
netbloc @funct 1 1 2 530 610 NJ
levelinfo -pg 1 0 370 670 1110 1320
pagesize -pg 1 -db -bbox -sgen -80 0 1320 660
show
fullfit
#
# initialize ictrl to current module top_MIPS work:top_MIPS:NOFILE
ictrl init topinfo |
