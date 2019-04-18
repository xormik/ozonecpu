VERSION 6
BEGIN SCHEMATIC
    BEGIN ATTR DeviceFamilyName "virtexe"
        DELETE all:0
        EDITNAME all:0
        EDITTRAIT all:0
    END ATTR
    BEGIN NETLIST
        SIGNAL "CKE"
        SIGNAL "CS"
        SIGNAL "RAS"
        SIGNAL "CAS"
        SIGNAL "WE"
        SIGNAL "addr(11:0)"
        SIGNAL "Ba(1:0)"
        SIGNAL "DQM(1:0)"
        SIGNAL "Data(31:16)"
        SIGNAL "Data(15:0)"
        SIGNAL "DRAMCLK"
        SIGNAL "dm_addr(31:0)"
        SIGNAL "dm_inst(31:0)"
        SIGNAL "memio_out(31:0)"
        SIGNAL "stat_output(7:0)"
        SIGNAL "Data(31:0)"
        SIGNAL "rst"
        SIGNAL "proc_rst"
        SIGNAL "rls"
        SIGNAL "memio_in(7:0)"
        SIGNAL "memio_outsel"
        SIGNAL "clk"
        SIGNAL "procclk"
        PORT Input "DRAMCLK"
        PORT Output "dm_addr(31:0)"
        PORT Output "dm_inst(31:0)"
        PORT Output "memio_out(31:0)"
        PORT Output "stat_output(7:0)"
        PORT Input "rst"
        PORT Input "rls"
        PORT Input "memio_in(7:0)"
        PORT Input "memio_outsel"
        PORT Input "clk"
        BEGIN BLOCKDEF "mt48lc8m16a2"
            TIMESTAMP 2003 11 27 4 14 40
            RECTANGLE N 64 -576 368 0 
            LINE N 64 -544 0 -544 
            LINE N 64 -480 0 -480 
            LINE N 64 -416 0 -416 
            LINE N 64 -352 0 -352 
            LINE N 64 -288 0 -288 
            LINE N 64 -224 0 -224 
            LINE N 64 -160 0 -160 
            RECTANGLE N 0 -172 64 -148 
            LINE N 64 -96 0 -96 
            RECTANGLE N 0 -108 64 -84 
            LINE N 64 -32 0 -32 
            RECTANGLE N 0 -44 64 -20 
            LINE N 368 -544 432 -544 
            RECTANGLE N 368 -556 432 -532 
        END BLOCKDEF
        BEGIN BLOCKDEF "delay_proc_rst"
            TIMESTAMP 2003 11 27 4 19 1
            RECTANGLE N 64 -192 432 0 
            LINE N 64 -160 0 -160 
            LINE N 64 -96 0 -96 
            LINE N 64 -32 0 -32 
            LINE N 432 -160 496 -160 
            LINE N 432 -32 496 -32 
        END BLOCKDEF
        BEGIN BLOCKDEF "processor"
            TIMESTAMP 2003 11 28 4 9 59
            RECTANGLE N 64 -832 560 0 
            LINE N 64 -800 0 -800 
            LINE N 64 -672 0 -672 
            LINE N 64 -544 0 -544 
            LINE N 64 -416 0 -416 
            RECTANGLE N 0 -428 64 -404 
            LINE N 64 -288 0 -288 
            LINE N 64 -160 0 -160 
            LINE N 64 -32 0 -32 
            LINE N 560 -800 624 -800 
            RECTANGLE N 560 -812 624 -788 
            LINE N 560 -96 624 -96 
            RECTANGLE N 560 -108 624 -84 
            LINE N 560 -32 624 -32 
            RECTANGLE N 560 -44 624 -20 
            LINE N 560 -608 624 -608 
            LINE N 560 -544 624 -544 
            RECTANGLE N 560 -556 624 -532 
            LINE N 560 -480 624 -480 
            LINE N 560 -416 624 -416 
            LINE N 560 -352 624 -352 
            LINE N 560 -288 624 -288 
            LINE N 560 -224 624 -224 
            RECTANGLE N 560 -236 624 -212 
            LINE N 560 -160 624 -160 
            RECTANGLE N 560 -172 624 -148 
            LINE N 560 -736 624 -736 
            RECTANGLE N 560 -748 624 -724 
            LINE N 560 -672 624 -672 
            RECTANGLE N 560 -684 624 -660 
        END BLOCKDEF
        BEGIN BLOCK "my_mem0" "mt48lc8m16a2"
            PIN "Clk" "DRAMCLK"
            PIN "Cke" "CKE"
            PIN "Cs_n" "CS"
            PIN "Ras_n" "RAS"
            PIN "Cas_n" "CAS"
            PIN "We_n" "WE"
            PIN "Addr(11:0)" "addr(11:0)"
            PIN "Ba(1:0)" "Ba(1:0)"
            PIN "Dqm(1:0)" "DQM(1:0)"
            PIN "Dq(15:0)" "Data(31:16)"
        END BLOCK
        BEGIN BLOCK "my_mem1" "mt48lc8m16a2"
            PIN "Clk" "DRAMCLK"
            PIN "Cke" "CKE"
            PIN "Cs_n" "CS"
            PIN "Ras_n" "RAS"
            PIN "Cas_n" "CAS"
            PIN "We_n" "WE"
            PIN "Addr(11:0)" "addr(11:0)"
            PIN "Ba(1:0)" "Ba(1:0)"
            PIN "Dqm(1:0)" "DQM(1:0)"
            PIN "Dq(15:0)" "Data(15:0)"
        END BLOCK
        BEGIN BLOCK "my_cpu" "processor"
            PIN "CLK" "procclk"
            PIN "RST" "proc_rst"
            PIN "rls" "rls"
            PIN "memio_in(7:0)" "memio_in(7:0)"
            PIN "memio_outsel" "memio_outsel"
            PIN "DRAMCLK" "DRAMCLK"
            PIN "mem_ctrl_rst" "rst"
            PIN "mem_BiData(31:0)" "Data(31:0)"
            PIN "dm_addr(31:0)" "dm_addr(31:0)"
            PIN "memio_out(31:0)" "memio_out(31:0)"
            PIN "stat_output(7:0)" "stat_output(7:0)"
            PIN "WE" "WE"
            PIN "addr(11:0)" "addr(11:0)"
            PIN "CAS" "CAS"
            PIN "RAS" "RAS"
            PIN "CS" "CS"
            PIN "CKE" "CKE"
            PIN "Ba(1:0)" "Ba(1:0)"
            PIN "DQM(1:0)" "DQM(1:0)"
            PIN "dm_instr(31:0)" "dm_inst(31:0)"
        END BLOCK
        BEGIN BLOCK "my_delay_proc_rst" "delay_proc_rst"
            PIN "rst" "rst"
            PIN "DRAMCLK" "DRAMCLK"
            PIN "PROCCLK_IN" "clk"
            PIN "PROCCLK_OUT" "procclk"
            PIN "proc_rst" "proc_rst"
        END BLOCK
    END NETLIST
    BEGIN SHEET 1 3520 2720
        BEGIN BRANCH "DRAMCLK"
            WIRE 2048 752 2064 752
            BEGIN DISPLAY 2048 752 ATTR "Name"
                ALIGNMENT SOFT-RIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "CS"
            WIRE 2048 880 2064 880
            BEGIN DISPLAY 2048 880 ATTR "Name"
                ALIGNMENT SOFT-RIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "RAS"
            WIRE 2048 944 2064 944
            BEGIN DISPLAY 2048 944 ATTR "Name"
                ALIGNMENT SOFT-RIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "CAS"
            WIRE 2048 1008 2064 1008
            BEGIN DISPLAY 2048 1008 ATTR "Name"
                ALIGNMENT SOFT-RIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "WE"
            WIRE 2048 1072 2064 1072
            BEGIN DISPLAY 2048 1072 ATTR "Name"
                ALIGNMENT SOFT-RIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "addr(11:0)"
            WIRE 2048 1136 2064 1136
            BEGIN DISPLAY 2048 1136 ATTR "Name"
                ALIGNMENT SOFT-RIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "Ba(1:0)"
            WIRE 2048 1200 2064 1200
            BEGIN DISPLAY 2048 1200 ATTR "Name"
                ALIGNMENT SOFT-RIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "DQM(1:0)"
            WIRE 2048 1264 2064 1264
            BEGIN DISPLAY 2048 1264 ATTR "Name"
                ALIGNMENT SOFT-RIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "Data(31:16)"
            WIRE 2496 752 2528 752
            WIRE 2528 752 2560 752
            BEGIN DISPLAY 2528 752 ATTR "Name"
                ALIGNMENT SOFT-BCENTER
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "DRAMCLK"
            WIRE 2048 1472 2064 1472
            BEGIN DISPLAY 2048 1472 ATTR "Name"
                ALIGNMENT SOFT-RIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "CS"
            WIRE 2048 1600 2064 1600
            BEGIN DISPLAY 2048 1600 ATTR "Name"
                ALIGNMENT SOFT-RIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "RAS"
            WIRE 2048 1664 2064 1664
            BEGIN DISPLAY 2048 1664 ATTR "Name"
                ALIGNMENT SOFT-RIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "CAS"
            WIRE 2048 1728 2064 1728
            BEGIN DISPLAY 2048 1728 ATTR "Name"
                ALIGNMENT SOFT-RIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "WE"
            WIRE 2048 1792 2064 1792
            BEGIN DISPLAY 2048 1792 ATTR "Name"
                ALIGNMENT SOFT-RIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "addr(11:0)"
            WIRE 2048 1856 2064 1856
            BEGIN DISPLAY 2048 1856 ATTR "Name"
                ALIGNMENT SOFT-RIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "Ba(1:0)"
            WIRE 2048 1920 2064 1920
            BEGIN DISPLAY 2048 1920 ATTR "Name"
                ALIGNMENT SOFT-RIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "DQM(1:0)"
            WIRE 2048 1984 2064 1984
            BEGIN DISPLAY 2048 1984 ATTR "Name"
                ALIGNMENT SOFT-RIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "Data(15:0)"
            WIRE 2496 1472 2528 1472
            WIRE 2528 1472 2560 1472
            BEGIN DISPLAY 2528 1472 ATTR "Name"
                ALIGNMENT SOFT-BCENTER
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "dm_addr(31:0)"
            WIRE 480 992 608 992
            WIRE 608 992 800 992
            WIRE 800 752 1600 752
            WIRE 1600 752 1600 864
            WIRE 800 752 800 992
            WIRE 1568 864 1600 864
            BEGIN DISPLAY 608 992 ATTR "Name"
                ALIGNMENT SOFT-BCENTER
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "dm_inst(31:0)"
            WIRE 480 912 608 912
            WIRE 608 912 752 912
            WIRE 752 704 752 912
            WIRE 752 704 1648 704
            WIRE 1648 704 1648 928
            WIRE 1568 928 1648 928
            BEGIN DISPLAY 608 912 ATTR "Name"
                ALIGNMENT SOFT-BCENTER
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "Data(31:0)"
            WIRE 1568 992 1648 992
            WIRE 1648 992 1760 992
            WIRE 1760 608 1760 992
            WIRE 1760 608 2688 608
            WIRE 2688 608 2688 752
            WIRE 2688 752 2688 1472
            WIRE 2656 752 2688 752
            WIRE 2656 1472 2688 1472
            BEGIN DISPLAY 1648 992 ATTR "Name"
                ALIGNMENT SOFT-BCENTER
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "CKE"
            WIRE 2048 1536 2064 1536
            BEGIN DISPLAY 2048 1536 ATTR "Name"
                ALIGNMENT SOFT-RIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "CKE"
            WIRE 2048 816 2064 816
            BEGIN DISPLAY 2048 816 ATTR "Name"
                ALIGNMENT SOFT-RIGHT
            END DISPLAY
        END BRANCH
        BUSTAP 2656 752 2560 752
        BUSTAP 2656 1472 2560 1472
        BEGIN INSTANCE "my_mem0" 2064 1296 R0
        END INSTANCE
        BEGIN INSTANCE "my_mem1" 2064 2016 R0
        END INSTANCE
        BEGIN INSTANCE "my_cpu" 944 1664 R0
        END INSTANCE
        BEGIN BRANCH "DQM(1:0)"
            WIRE 1568 1504 1584 1504
            BEGIN DISPLAY 1584 1504 ATTR "Name"
                ALIGNMENT SOFT-LEFT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "Ba(1:0)"
            WIRE 1568 1440 1584 1440
            BEGIN DISPLAY 1584 1440 ATTR "Name"
                ALIGNMENT SOFT-LEFT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "CAS"
            WIRE 1568 1184 1584 1184
            BEGIN DISPLAY 1584 1184 ATTR "Name"
                ALIGNMENT SOFT-LEFT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "RAS"
            WIRE 1568 1248 1584 1248
            BEGIN DISPLAY 1584 1248 ATTR "Name"
                ALIGNMENT SOFT-LEFT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "CS"
            WIRE 1568 1312 1584 1312
            BEGIN DISPLAY 1584 1312 ATTR "Name"
                ALIGNMENT SOFT-LEFT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "addr(11:0)"
            WIRE 1568 1120 1584 1120
            BEGIN DISPLAY 1584 1120 ATTR "Name"
                ALIGNMENT SOFT-LEFT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "WE"
            WIRE 1568 1056 1584 1056
            BEGIN DISPLAY 1584 1056 ATTR "Name"
                ALIGNMENT SOFT-LEFT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "CKE"
            WIRE 1568 1376 1584 1376
            BEGIN DISPLAY 1584 1376 ATTR "Name"
                ALIGNMENT SOFT-LEFT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "procclk"
            WIRE 928 864 944 864
            BEGIN DISPLAY 928 864 ATTR "Name"
                ALIGNMENT SOFT-RIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "proc_rst"
            WIRE 928 992 944 992
            BEGIN DISPLAY 928 992 ATTR "Name"
                ALIGNMENT SOFT-RIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "memio_in(7:0)"
            WIRE 480 1248 944 1248
        END BRANCH
        IOMARKER 480 1120 "rls" R180 28
        IOMARKER 480 1248 "memio_in(7:0)" R180 28
        BEGIN BRANCH "stat_output(7:0)"
            WIRE 480 1696 480 1712
            WIRE 480 1712 640 1712
            WIRE 640 1712 1600 1712
            WIRE 1568 1632 1600 1632
            WIRE 1600 1632 1600 1712
            BEGIN DISPLAY 640 1712 ATTR "Name"
                ALIGNMENT SOFT-BCENTER
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "rst"
            WIRE 848 1632 880 1632
            WIRE 880 1632 944 1632
            BEGIN DISPLAY 880 1632 ATTR "Name"
                ALIGNMENT SOFT-BCENTER
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "DRAMCLK"
            WIRE 480 1504 944 1504
        END BRANCH
        IOMARKER 480 1504 "DRAMCLK" R180 28
        BEGIN BRANCH "memio_outsel"
            WIRE 480 1376 944 1376
        END BRANCH
        IOMARKER 480 1376 "memio_outsel" R180 28
        IOMARKER 480 1696 "stat_output(7:0)" R180 28
        IOMARKER 480 1760 "memio_out(31:0)" R180 28
        BEGIN BRANCH "memio_out(31:0)"
            WIRE 480 1760 1648 1760
            WIRE 1568 1568 1648 1568
            WIRE 1648 1568 1648 1760
        END BRANCH
        IOMARKER 480 992 "dm_addr(31:0)" R180 28
        BEGIN BRANCH "rls"
            WIRE 480 1120 944 1120
        END BRANCH
        IOMARKER 480 912 "dm_inst(31:0)" R180 28
        BEGIN BRANCH "rst"
            WIRE 480 1920 496 1920
            WIRE 496 1920 656 1920
        END BRANCH
        BEGIN BRANCH "DRAMCLK"
            WIRE 640 1984 656 1984
            BEGIN DISPLAY 640 1984 ATTR "Name"
                ALIGNMENT SOFT-RIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "clk"
            WIRE 480 2048 496 2048
            WIRE 496 2048 656 2048
        END BRANCH
        BEGIN INSTANCE "my_delay_proc_rst" 656 2080 R0
        END INSTANCE
        IOMARKER 480 1920 "rst" R180 28
        IOMARKER 480 2048 "clk" R180 28
        BEGIN BRANCH "proc_rst"
            WIRE 1152 2048 1168 2048
            BEGIN DISPLAY 1168 2048 ATTR "Name"
                ALIGNMENT SOFT-LEFT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "procclk"
            WIRE 1152 1920 1168 1920
            BEGIN DISPLAY 1168 1920 ATTR "Name"
                ALIGNMENT SOFT-LEFT
            END DISPLAY
        END BRANCH
    END SHEET
END SCHEMATIC
