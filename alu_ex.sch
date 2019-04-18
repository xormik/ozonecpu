VERSION 6
BEGIN SCHEMATIC
    BEGIN ATTR DeviceFamilyName "virtexe"
        DELETE all:0
        EDITNAME all:0
        EDITTRAIT all:0
    END ATTR
    BEGIN NETLIST
        SIGNAL "XLXN_12(31:0)"
        SIGNAL "XLXN_13(31:0)"
        SIGNAL "XLXN_5"
        SIGNAL "XLXN_6"
        SIGNAL "XLXN_7(31:0)"
        SIGNAL "XLXN_8(31:0)"
        SIGNAL "XLXN_9(31:0)"
        SIGNAL "din1(31:0)"
        SIGNAL "din2(31:0)"
        SIGNAL "din1(31)"
        SIGNAL "din2(31)"
        SIGNAL "alu_ctrl(3)"
        SIGNAL "alu_ctrl(2:0)"
        SIGNAL "alu_ctrl(1:0)"
        SIGNAL "alu_ctrl(5:4)"
        SIGNAL "dout(31:0)"
        SIGNAL "alu_ctrl(5:0)"
        SIGNAL "din1(4:0)"
        SIGNAL "XLXN_61"
        PORT Input "din1(31:0)"
        PORT Input "din2(31:0)"
        PORT Output "dout(31:0)"
        PORT Input "alu_ctrl(5:0)"
        BEGIN BLOCKDEF "alu"
            TIMESTAMP 2003 10 11 9 6 48
            LINE N 144 -240 80 -240 
            RECTANGLE N 80 -252 144 -228 
            LINE N 144 0 80 0 
            RECTANGLE N 80 -12 144 12 
            LINE N 208 96 208 32 
            RECTANGLE N 192 32 224 96 
            LINE N 288 -80 352 -80 
            LINE N 288 -48 352 -48 
            LINE N 288 -128 352 -128 
            RECTANGLE N 288 -140 352 -116 
            LINE N 144 -320 144 -144 
            LINE N 192 -112 144 -144 
            LINE N 192 -112 144 -80 
            LINE N 144 84 144 -80 
            LINE N 144 84 288 -32 
            LINE N 288 -32 288 -192 
            LINE N 288 -192 144 -320 
        END BLOCKDEF
        BEGIN BLOCKDEF "shifter"
            TIMESTAMP 2003 10 12 5 12 12
            LINE N 80 -144 16 -144 
            LINE N 80 -48 16 -48 
            RECTANGLE N 16 -60 80 -36 
            LINE N 32 -96 -32 -96 
            RECTANGLE N -32 -108 32 -84 
            LINE N 496 -96 560 -96 
            RECTANGLE N 496 -108 560 -84 
            LINE N 496 -96 416 -176 
            LINE N 496 -96 416 -16 
            LINE N 32 -96 112 -176 
            LINE N 32 -96 112 -16 
            LINE N 112 -176 416 -176 
            LINE N 112 -16 416 -16 
        END BLOCKDEF
        BEGIN BLOCKDEF "slt_block"
            TIMESTAMP 2003 10 12 14 14 55
            RECTANGLE N 68 -320 320 -140 
            LINE N 64 -288 0 -288 
            LINE N 64 -256 0 -256 
            LINE N 64 -224 0 -224 
            LINE N 64 -192 0 -192 
            LINE N 64 -160 0 -160 
            LINE N 320 -288 384 -288 
            RECTANGLE N 320 -300 384 -276 
        END BLOCKDEF
        BEGIN BLOCKDEF "m32x3"
            TIMESTAMP 2003 10 23 4 44 33
            LINE N 160 -192 96 -192 
            RECTANGLE N 96 -204 160 -180 
            LINE N 160 -128 96 -128 
            RECTANGLE N 96 -140 160 -116 
            LINE N 160 -64 96 -64 
            RECTANGLE N 96 -76 160 -52 
            LINE N 208 -320 208 -240 
            RECTANGLE N 192 -320 224 -240 
            LINE N 256 -128 320 -128 
            RECTANGLE N 256 -140 320 -116 
            LINE N 160 -272 256 -208 
            LINE N 160 -272 160 16 
            LINE N 256 -208 256 -64 
            LINE N 256 -64 160 16 
        END BLOCKDEF
        BEGIN BLOCK "XLXI_2" "alu"
            PIN "A(31:0)" "din1(31:0)"
            PIN "B(31:0)" "din2(31:0)"
            PIN "FSEL(2:0)" "alu_ctrl(2:0)"
            PIN "NEG" "XLXN_5"
            PIN "OVF" "XLXN_6"
            PIN "DOUT(31:0)" "XLXN_7(31:0)"
        END BLOCK
        BEGIN BLOCK "XLXI_3" "shifter"
            PIN "shiftType(1:0)" "alu_ctrl(1:0)"
            PIN "shiftAmt(4:0)" "din1(4:0)"
            PIN "in0(31:0)" "din2(31:0)"
            PIN "out0(31:0)" "XLXN_9(31:0)"
        END BLOCK
        BEGIN BLOCK "XLXI_4" "slt_block"
            PIN "NEG" "XLXN_5"
            PIN "OVF" "XLXN_6"
            PIN "SltType" "alu_ctrl(3)"
            PIN "signInput1" "din1(31)"
            PIN "signInput2" "din2(31)"
            PIN "result(31:0)" "XLXN_8(31:0)"
        END BLOCK
        BEGIN BLOCK "XLXI_6" "m32x3"
            PIN "in0(31:0)" "XLXN_7(31:0)"
            PIN "in1(31:0)" "XLXN_8(31:0)"
            PIN "in2(31:0)" "XLXN_9(31:0)"
            PIN "sel(1:0)" "alu_ctrl(5:4)"
            PIN "out0(31:0)" "dout(31:0)"
        END BLOCK
    END NETLIST
    BEGIN SHEET 1 2720 1760
        BEGIN INSTANCE "XLXI_2" 656 928 R0
        END INSTANCE
        BEGIN BRANCH "XLXN_5"
            WIRE 1008 848 1200 848
        END BRANCH
        BEGIN BRANCH "XLXN_6"
            WIRE 1008 880 1200 880
        END BRANCH
        BEGIN BRANCH "XLXN_7(31:0)"
            WIRE 1008 800 1088 800
            WIRE 1088 720 1088 800
            WIRE 1088 720 1856 720
            WIRE 1856 720 1856 976
            WIRE 1856 976 1984 976
        END BRANCH
        BEGIN BRANCH "XLXN_8(31:0)"
            WIRE 1584 848 1776 848
            WIRE 1776 848 1776 1040
            WIRE 1776 1040 1984 1040
        END BRANCH
        BEGIN BRANCH "XLXN_9(31:0)"
            WIRE 1520 1440 1856 1440
            WIRE 1856 1104 1856 1440
            WIRE 1856 1104 1984 1104
        END BRANCH
        BEGIN INSTANCE "XLXI_3" 960 1536 R0
        END INSTANCE
        BEGIN BRANCH "din1(31:0)"
            WIRE 368 688 592 688
            WIRE 592 688 736 688
            WIRE 592 688 592 1040
        END BRANCH
        BEGIN BRANCH "din2(31:0)"
            WIRE 368 928 464 928
            WIRE 464 928 464 1440
            WIRE 464 1440 928 1440
            WIRE 464 928 736 928
        END BRANCH
        BEGIN INSTANCE "XLXI_4" 1200 1136 R0
        END INSTANCE
        BEGIN BRANCH "din1(31)"
            WIRE 1152 944 1200 944
            BEGIN DISPLAY 1152 944 ATTR "Name"
                ALIGNMENT SOFT-RIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "din2(31)"
            WIRE 1152 976 1200 976
            BEGIN DISPLAY 1152 976 ATTR "Name"
                ALIGNMENT SOFT-RIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "alu_ctrl(3)"
            WIRE 1152 912 1200 912
            BEGIN DISPLAY 1152 912 ATTR "Name"
                ALIGNMENT SOFT-RIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "alu_ctrl(2:0)"
            WIRE 864 1024 864 1072
            BEGIN DISPLAY 864 1072 ATTR "Name"
                ALIGNMENT SOFT-VRIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "alu_ctrl(1:0)"
            WIRE 880 1392 976 1392
            BEGIN DISPLAY 880 1392 ATTR "Name"
                ALIGNMENT SOFT-RIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "alu_ctrl(5:4)"
            WIRE 2096 784 2096 848
            WIRE 2096 848 2096 864
            BEGIN DISPLAY 2096 784 ATTR "Name"
                ALIGNMENT SOFT-VLEFT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "dout(31:0)"
            WIRE 2208 1040 2224 1040
            WIRE 2224 1040 2400 1040
        END BRANCH
        INSTANCE "XLXI_6" 1888 1168 R0
        BEGIN BRANCH "alu_ctrl(5:0)"
            WIRE 1248 416 1248 512
        END BRANCH
        IOMARKER 368 688 "din1(31:0)" R180 28
        IOMARKER 368 928 "din2(31:0)" R180 28
        IOMARKER 1248 416 "alu_ctrl(5:0)" R270 28
        IOMARKER 2400 1040 "dout(31:0)" R0 28
        BUSTAP 592 1040 592 1136
        BEGIN BRANCH "din1(4:0)"
            WIRE 592 1136 592 1248
            WIRE 592 1248 592 1488
            WIRE 592 1488 976 1488
            BEGIN DISPLAY 592 1248 ATTR "Name"
                ALIGNMENT SOFT-TVCENTER
            END DISPLAY
        END BRANCH
    END SHEET
END SCHEMATIC
