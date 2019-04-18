VERSION 6
BEGIN SCHEMATIC
    BEGIN ATTR DeviceFamilyName "virtexe"
        DELETE all:0
        EDITNAME all:0
        EDITTRAIT all:0
    END ATTR
    BEGIN NETLIST
        SIGNAL "CLK"
        SIGNAL "RST"
        SIGNAL "cycle_count(63:0)"
        SIGNAL "cdb_dout(132:0)"
        SIGNAL "cdb_dout_en"
        SIGNAL "rob_destOUT(22:0)"
        SIGNAL "rollback"
        SIGNAL "rob_valueOUT(31:0)"
        SIGNAL "rob_destOUT(4:0)"
        SIGNAL "GND"
        SIGNAL "VCC"
        SIGNAL "dispatch_rs(4:0)"
        SIGNAL "dispatch_RSVj(31:0)"
        SIGNAL "dispatch_RSVk(31:0)"
        SIGNAL "dispatch_RSQj(4:0)"
        SIGNAL "dispatch_RSQk(4:0)"
        SIGNAL "dispatch_rsH(4:0)"
        SIGNAL "dispatch_rtH(4:0)"
        SIGNAL "dispatch_aluOp(5:0)"
        SIGNAL "dispatch_RSBusy"
        SIGNAL "dispatch_swIssue"
        SIGNAL "dispatch_lwIssue"
        SIGNAL "XLXN_332"
        SIGNAL "dispatch_aluIssue"
        SIGNAL "dispatch_branchIssue"
        SIGNAL "dispatch_rt(4:0)"
        SIGNAL "regfile_rtData(31:0)"
        SIGNAL "regfile_rsData(31:0)"
        SIGNAL "instrOUT(31:0)"
        SIGNAL "regFileCommit"
        SIGNAL "regStatCommit"
        SIGNAL "robReady"
        SIGNAL "robFull"
        SIGNAL "rob_readValueOUT2(31:0)"
        SIGNAL "zeroes(22:0)"
        SIGNAL "dReorder(4:0)"
        SIGNAL "addrOUT(31:0)"
        SIGNAL "rob_addrOUT(31:0)"
        SIGNAL "rsHReady"
        SIGNAL "rtHReady"
        SIGNAL "targetAddr(31:0)"
        SIGNAL "Corona(31:0)"
        SIGNAL "XLXN_161"
        SIGNAL "XLXN_828"
        SIGNAL "XLXN_830"
        SIGNAL "XLXN_876(100:0)"
        SIGNAL "branchFull"
        SIGNAL "can_opener"
        SIGNAL "mux_nextPC(31:0)"
        SIGNAL "dm_addr(31:0)"
        SIGNAL "rls"
        SIGNAL "memio_in(7:0)"
        SIGNAL "memio_outsel"
        SIGNAL "memio_out(31:0)"
        SIGNAL "stat_output(7:0)"
        SIGNAL "WE"
        SIGNAL "addr(11:0)"
        SIGNAL "CAS"
        SIGNAL "RAS"
        SIGNAL "CS"
        SIGNAL "CKE"
        SIGNAL "DRAMCLK"
        SIGNAL "Ba(1:0)"
        SIGNAL "DQM(1:0)"
        SIGNAL "mem_ctrl_rst"
        SIGNAL "mem_BiData(31:0)"
        SIGNAL "aluFull"
        SIGNAL "regStatus_rsReorder(4:0)"
        SIGNAL "regStatus_rtReorder(4:0)"
        SIGNAL "rob_issuePtr(4:0)"
        SIGNAL "dispatch_writeReg(5:0)"
        SIGNAL "dispatch_writeRegROBEntry(4:0)"
        SIGNAL "cdb_dout(36:0)"
        SIGNAL "dispatch_robIssue"
        SIGNAL "dispatch_regStatIssue"
        SIGNAL "commit_robCommit"
        SIGNAL "rob_commitPtr(4:0)"
        SIGNAL "dm_instr(31:0)"
        SIGNAL "zeroes(255:0)"
        SIGNAL "zeroes(132:0)"
        SIGNAL "rob_readValueOUT1(31:0)"
        SIGNAL "rob_valueOUT(63:0)"
        SIGNAL "airplane"
        SIGNAL "orangina(31:0)"
        SIGNAL "instrOUT(1)"
        SIGNAL "XLXN_73"
        SIGNAL "XLXN_74(100:0)"
        SIGNAL "XLXN_75"
        SIGNAL "XLXN_34(31:0)"
        SIGNAL "XLXN_35(31:0)"
        SIGNAL "XLXN_36(5:0)"
        SIGNAL "XLXN_37(31:0)"
        SIGNAL "XLXN_13(31:0)"
        SIGNAL "adder_pc4(31:0)"
        SIGNAL "zeroes(31:0)"
        SIGNAL "pc_addrOUT(24:2)"
        SIGNAL "pc_addrOUT(6:2)"
        SIGNAL "XLXN_1375(31:0)"
        SIGNAL "rob_destOUT(5:0)"
        SIGNAL "dispatch_rs(5:0)"
        SIGNAL "pc_addrOUT(31:0)"
        SIGNAL "XLXN_1388(31:0)"
        SIGNAL "pc_addrOUT(31)"
        SIGNAL "XLXN_1127(31:0)"
        SIGNAL "XLXN_1128(31:0)"
        SIGNAL "XLXN_1129(31:0)"
        SIGNAL "XLXN_1130(31:0)"
        SIGNAL "dispatch_rs(5)"
        SIGNAL "regfile_rsData_pre(31:0)"
        SIGNAL "XLXN_433"
        SIGNAL "cdb_dout(68:0)"
        SIGNAL "cdb_dout(36:32)"
        SIGNAL "cdb_dout(132:69)"
        SIGNAL "BU_targetAddr(31:0)"
        SIGNAL "zeroes(4:0)"
        SIGNAL "dispatch_ROBEntryReady"
        SIGNAL "dispatch_rd(4:0)"
        SIGNAL "dispatch_RSAddr(31:0)"
        SIGNAL "pcMuxSel(1:0)"
        SIGNAL "XLXN_1419"
        SIGNAL "load_buffer_addr_out(22:0)"
        SIGNAL "cache_line(255:0)"
        SIGNAL "readBuffer_WE"
        SIGNAL "inst_we_gate"
        SIGNAL "data_we_gate"
        SIGNAL "XLXN_633(31:0)"
        SIGNAL "Corona(15:0)"
        SIGNAL "branchUnit_stall"
        SIGNAL "burstReadDone"
        SIGNAL "XLXN_1679"
        SIGNAL "XLXN_1684(2:0)"
        SIGNAL "mem_r_w"
        SIGNAL "mem_addr(22:0)"
        SIGNAL "mem_data(31:0)"
        SIGNAL "mem_request"
        SIGNAL "lwFull"
        SIGNAL "swFull"
        SIGNAL "XLXN_1720(68:0)"
        SIGNAL "data_req"
        SIGNAL "XLXN_1727"
        SIGNAL "XLXN_1729(68:0)"
        SIGNAL "dispatch_RSVstore(31:0)"
        SIGNAL "dispatch_RSQstore(4:0)"
        SIGNAL "dispatch_RSVk(15:0)"
        SIGNAL "store_buffer_req_bus"
        SIGNAL "rob_loadData(31:0)"
        SIGNAL "rob_loadDataValid"
        SIGNAL "use_memio"
        SIGNAL "XLXN_239(31:0)"
        SIGNAL "XLXN_1710"
        SIGNAL "XLXN_1594"
        SIGNAL "commit_writeCache"
        SIGNAL "arbiter_WB_granted"
        SIGNAL "memio_dout(31:0)"
        SIGNAL "store_buffer_addr_out(28:0)"
        SIGNAL "XLXN_1925(31:0)"
        SIGNAL "XLXN_1926(31:0)"
        SIGNAL "waitForMem"
        SIGNAL "XLXN_1928"
        SIGNAL "XLXN_1931"
        SIGNAL "inst_req"
        SIGNAL "inst_mem_addr(22:0)"
        SIGNAL "data_mem_addr(22:0)"
        SIGNAL "reg_HI_LO(31:0)"
        SIGNAL "rob_readPredAddr(31:0)"
        SIGNAL "commit_regFileOut(31:0)"
        SIGNAL "commit_writeRegBusy"
        SIGNAL "commit_writeReg(4:0)"
        SIGNAL "commit_rollBack"
        SIGNAL "addr_notTaken(31:0)"
        SIGNAL "addr_taken(31:0)"
        SIGNAL "dispatch_jrStall"
        SIGNAL "XLXN_1937"
        SIGNAL "dispatch_branchOp(1:0)"
        PORT Input "CLK"
        PORT Input "RST"
        PORT Output "dm_addr(31:0)"
        PORT Input "rls"
        PORT Input "memio_in(7:0)"
        PORT Input "memio_outsel"
        PORT Output "memio_out(31:0)"
        PORT Output "stat_output(7:0)"
        PORT Output "WE"
        PORT Output "addr(11:0)"
        PORT Output "CAS"
        PORT Output "RAS"
        PORT Output "CS"
        PORT Output "CKE"
        PORT Input "DRAMCLK"
        PORT Output "Ba(1:0)"
        PORT Output "DQM(1:0)"
        PORT Input "mem_ctrl_rst"
        PORT BiDirectional "mem_BiData(31:0)"
        PORT Output "dm_instr(31:0)"
        BEGIN BLOCKDEF "pc"
            TIMESTAMP 2003 11 24 4 0 57
            RECTANGLE N 96 -256 288 0 
            LINE N 96 -80 32 -80 
            RECTANGLE N 32 -92 96 -68 
            LINE N 288 -176 352 -176 
            RECTANGLE N 288 -188 352 -164 
            LINE N 192 -32 160 0 
            LINE N 192 -32 224 0 
            LINE N 192 0 192 64 
            LINE N 224 -320 224 -256 
            LINE N 160 -320 160 -256 
        END BLOCKDEF
        BEGIN BLOCKDEF "ireg"
            TIMESTAMP 2003 11 26 23 38 2
            LINE N 64 -128 0 -128 
            RECTANGLE N 0 -140 64 -116 
            LINE N 64 -80 0 -80 
            RECTANGLE N 0 -92 64 -68 
            LINE N 272 48 336 48 
            RECTANGLE N 272 36 336 60 
            LINE N 272 -16 336 -16 
            RECTANGLE N 272 -28 336 -4 
            LINE N 64 -224 0 -224 
            LINE N 64 -192 0 -192 
            RECTANGLE N 64 -256 272 128 
            LINE N 160 96 132 128 
            LINE N 160 96 196 128 
        END BLOCKDEF
        BEGIN BLOCKDEF "vcc"
            TIMESTAMP 2001 2 2 12 24 11
            LINE N 64 -32 64 -64 
            LINE N 64 0 64 -32 
            LINE N 96 -64 32 -64 
        END BLOCKDEF
        BEGIN BLOCKDEF "adder"
            TIMESTAMP 2003 11 17 9 42 15
            LINE N 176 -48 112 -48 
            RECTANGLE N 112 -60 176 -36 
            LINE N 176 192 112 192 
            RECTANGLE N 112 180 176 204 
            LINE N 320 80 384 80 
            RECTANGLE N 320 68 384 92 
            LINE N 176 -128 176 48 
            LINE N 224 80 176 48 
            LINE N 224 80 176 112 
            LINE N 176 276 176 112 
            LINE N 176 276 320 160 
            LINE N 320 160 320 0 
            LINE N 320 0 176 -128 
        END BLOCKDEF
        BEGIN BLOCKDEF "four"
            TIMESTAMP 2003 11 17 9 42 19
            RECTANGLE N 64 -64 320 0 
            LINE N 320 -32 384 -32 
            RECTANGLE N 320 -44 384 -20 
        END BLOCKDEF
        BEGIN BLOCKDEF "dmdb_dispatch"
            TIMESTAMP 2003 11 22 12 14 49
            RECTANGLE N 64 -320 368 0 
            LINE N 64 -288 0 -288 
            LINE N 64 -224 0 -224 
            LINE N 64 -160 0 -160 
            RECTANGLE N 0 -172 64 -148 
            LINE N 64 -96 0 -96 
            RECTANGLE N 0 -108 64 -84 
            LINE N 64 -32 0 -32 
            RECTANGLE N 0 -44 64 -20 
        END BLOCKDEF
        BEGIN BLOCKDEF "counter64"
            TIMESTAMP 2003 11 22 12 14 49
            LINE N 352 32 416 32 
            RECTANGLE N 352 20 416 44 
            LINE N 64 -160 0 -160 
            LINE N 64 -96 0 -96 
            LINE N 64 -32 0 -32 
            RECTANGLE N 64 -192 352 64 
        END BLOCKDEF
        BEGIN BLOCKDEF "alu_res_stations"
            TIMESTAMP 2003 11 26 8 9 17
            RECTANGLE N 64 -896 640 -224 
            LINE N 64 -720 0 -720 
            LINE N 64 -656 0 -656 
            RECTANGLE N 0 -668 64 -644 
            LINE N 64 -592 0 -592 
            RECTANGLE N 0 -604 64 -580 
            LINE N 64 -528 0 -528 
            RECTANGLE N 0 -540 64 -516 
            LINE N 64 -464 0 -464 
            RECTANGLE N 0 -476 64 -452 
            LINE N 64 -400 0 -400 
            RECTANGLE N 0 -412 64 -388 
            LINE N 64 -336 0 -336 
            RECTANGLE N 0 -348 64 -324 
            LINE N 704 -688 640 -688 
            RECTANGLE N 640 -700 704 -676 
            LINE N 640 -800 704 -800 
            LINE N 528 -224 528 -156 
            LINE N 640 -544 704 -544 
            RECTANGLE N 640 -556 704 -532 
            LINE N 640 -464 704 -464 
            RECTANGLE N 640 -476 704 -452 
            LINE N 640 -384 704 -384 
            RECTANGLE N 640 -396 704 -372 
            RECTANGLE N 356 -224 380 -160 
            LINE N 368 -224 368 -160 
            LINE N 400 -896 368 -864 
            LINE N 336 -896 368 -864 
            LINE N 368 -896 368 -960 
            LINE N 208 -224 208 -156 
            LINE N 464 -896 464 -960 
            LINE N 560 -896 560 -960 
            LINE N 240 -960 240 -896 
            RECTANGLE N 228 -960 252 -896 
            LINE N 144 -960 144 -896 
        END BLOCKDEF
        BEGIN BLOCKDEF "alu_ex"
            TIMESTAMP 2003 11 17 13 17 53
            LINE N 80 -208 16 -208 
            RECTANGLE N 16 -220 80 -196 
            LINE N 80 -16 16 -16 
            RECTANGLE N 16 -28 80 -4 
            LINE N 224 -112 288 -112 
            RECTANGLE N 224 -124 288 -100 
            LINE N 80 84 80 -80 
            LINE N 128 -112 80 -80 
            LINE N 128 -112 80 -144 
            LINE N 80 -320 80 -144 
            LINE N 224 -192 80 -320 
            LINE N 224 -32 224 -192 
            LINE N 80 84 224 -32 
            RECTANGLE N 128 32 160 96 
            LINE N 144 96 144 32 
        END BLOCKDEF
        BEGIN BLOCKDEF "regfile"
            TIMESTAMP 2003 11 17 9 42 23
            RECTANGLE N 80 -368 400 80 
            LINE N 320 -432 320 -368 
            LINE N 160 -432 160 -368 
            LINE N 80 -288 16 -288 
            RECTANGLE N 16 -300 80 -276 
            LINE N 80 -192 16 -192 
            RECTANGLE N 16 -204 80 -180 
            LINE N 80 -80 16 -80 
            RECTANGLE N 16 -92 80 -68 
            LINE N 80 16 16 16 
            RECTANGLE N 16 4 80 28 
            LINE N 400 -240 464 -240 
            RECTANGLE N 400 -252 464 -228 
            LINE N 400 -48 464 -48 
            RECTANGLE N 400 -60 464 -36 
            LINE N 240 80 240 132 
            LINE N 216 80 240 56 
            LINE N 240 56 264 80 
        END BLOCKDEF
        BEGIN BLOCKDEF "cdb"
            TIMESTAMP 2003 11 25 8 9 24
            RECTANGLE N -2320 -160 3148 0 
            LINE N 2384 -160 2384 -224 
            LINE N -2320 -112 -2384 -112 
            LINE N -2320 -48 -2384 -48 
            LINE N 2800 0 2800 68 
            RECTANGLE N 2788 0 2812 64 
            LINE N -2320 -144 -2288 -112 
            LINE N -2288 -112 -2320 -80 
            RECTANGLE N 2532 -224 2556 -160 
            LINE N 2544 -224 2544 -156 
            LINE N 2704 -160 2704 -224 
            LINE N -928 -160 -928 -224 
            RECTANGLE N -780 -224 -756 -160 
            LINE N -768 -224 -768 -156 
            LINE N -608 -160 -608 -224 
            LINE N 1248 -160 1248 -224 
            RECTANGLE N 1396 -224 1420 -160 
            LINE N 1408 -224 1408 -156 
            LINE N 1568 -160 1568 -224 
            LINE N 2640 0 2640 68 
            LINE N 192 -160 192 -224 
            RECTANGLE N 340 -224 364 -160 
            LINE N 352 -224 352 -156 
            LINE N 512 -160 512 -224 
            LINE N -1984 -160 -1984 -224 
            RECTANGLE N -1836 -224 -1812 -160 
            LINE N -1824 -224 -1824 -156 
            LINE N -1664 -160 -1664 -224 
        END BLOCKDEF
        BEGIN BLOCKDEF "cache"
            TIMESTAMP 2003 11 28 23 15 51
            LINE N 80 -112 16 -112 
            LINE N 80 -304 16 -304 
            RECTANGLE N 16 -316 80 -292 
            LINE N 80 -176 16 -176 
            RECTANGLE N 16 -124 80 -100 
            LINE N 240 -432 240 -368 
            RECTANGLE N 228 -432 252 -368 
            LINE N 160 -432 160 -368 
            LINE N 80 -240 16 -240 
            RECTANGLE N 16 -252 80 -228 
            LINE N 320 -304 384 -304 
            LINE N 320 -128 384 -128 
            RECTANGLE N 320 -140 384 -116 
            RECTANGLE N 80 -368 320 -48 
            RECTANGLE N 320 -252 384 -228 
            LINE N 320 -240 384 -240 
            LINE N 208 -84 172 -48 
            LINE N 208 -84 244 -48 
            LINE N 208 -48 208 16 
            LINE N 144 -48 144 16 
            LINE N 272 -48 272 16 
        END BLOCKDEF
        BEGIN BLOCKDEF "dispatch"
            TIMESTAMP 2003 11 29 10 38 40
            LINE N 64 -80 0 -80 
            RECTANGLE N 0 -92 64 -68 
            LINE N 624 -96 688 -96 
            RECTANGLE N 624 -108 688 -84 
            LINE N 624 -32 688 -32 
            RECTANGLE N 624 -44 688 -20 
            LINE N 64 -1568 0 -1568 
            LINE N 64 -1488 0 -1488 
            LINE N 64 -1408 0 -1408 
            LINE N 64 -1328 0 -1328 
            LINE N 64 -1248 0 -1248 
            LINE N 64 -1168 0 -1168 
            LINE N 64 -1088 0 -1088 
            LINE N 64 -1008 0 -1008 
            LINE N 64 -928 0 -928 
            LINE N 64 -848 0 -848 
            RECTANGLE N 0 -860 64 -836 
            LINE N 64 -768 0 -768 
            RECTANGLE N 0 -780 64 -756 
            LINE N 64 -688 0 -688 
            RECTANGLE N 0 -700 64 -676 
            LINE N 64 -608 0 -608 
            RECTANGLE N 0 -620 64 -596 
            LINE N 64 -528 0 -528 
            RECTANGLE N 0 -540 64 -516 
            LINE N 64 -448 0 -448 
            RECTANGLE N 0 -460 64 -436 
            LINE N 64 -368 0 -368 
            RECTANGLE N 0 -380 64 -356 
            LINE N 64 -288 0 -288 
            RECTANGLE N 0 -300 64 -276 
            LINE N 624 -1568 688 -1568 
            LINE N 624 -1504 688 -1504 
            LINE N 624 -1440 688 -1440 
            LINE N 624 -1376 688 -1376 
            LINE N 624 -1312 688 -1312 
            LINE N 624 -1248 688 -1248 
            LINE N 624 -1184 688 -1184 
            LINE N 624 -1120 688 -1120 
            LINE N 624 -1024 688 -1024 
            RECTANGLE N 624 -1036 688 -1012 
            LINE N 624 -960 688 -960 
            RECTANGLE N 624 -972 688 -948 
            LINE N 624 -896 688 -896 
            RECTANGLE N 624 -908 688 -884 
            LINE N 624 -800 688 -800 
            RECTANGLE N 624 -812 688 -788 
            LINE N 624 -736 688 -736 
            RECTANGLE N 624 -748 688 -724 
            LINE N 624 -672 688 -672 
            RECTANGLE N 624 -684 688 -660 
            LINE N 624 -608 688 -608 
            RECTANGLE N 624 -620 688 -596 
            LINE N 624 -544 688 -544 
            RECTANGLE N 624 -556 688 -532 
            LINE N 624 -480 688 -480 
            RECTANGLE N 624 -492 688 -468 
            LINE N 624 -416 688 -416 
            RECTANGLE N 624 -428 688 -404 
            LINE N 624 -256 688 -256 
            RECTANGLE N 624 -268 688 -244 
            RECTANGLE N 64 -1600 624 68 
            LINE N 368 -1664 368 -1600 
            RECTANGLE N 356 -1664 380 -1600 
            LINE N 272 -1664 272 -1600 
            LINE N 624 32 688 32 
            LINE N 624 -320 688 -320 
            LINE N 624 -192 688 -192 
            RECTANGLE N 624 -204 688 -180 
            LINE N 688 -144 624 -144 
            RECTANGLE N 624 -332 688 -308 
        END BLOCKDEF
        BEGIN BLOCKDEF "gnd"
            TIMESTAMP 2001 2 2 12 24 11
            LINE N 64 -64 64 -96 
            LINE N 76 -48 52 -48 
            LINE N 68 -32 60 -32 
            LINE N 88 -64 40 -64 
            LINE N 64 -64 64 -80 
            LINE N 64 -128 64 -96 
        END BLOCKDEF
        BEGIN BLOCKDEF "reg_status"
            TIMESTAMP 2003 11 26 23 38 8
            RECTANGLE N 64 -576 656 -128 
            LINE N 64 -480 0 -480 
            LINE N 240 -640 240 -576 
            LINE N 64 -416 0 -416 
            RECTANGLE N 0 -428 64 -404 
            LINE N 64 -352 0 -352 
            RECTANGLE N 0 -364 64 -340 
            RECTANGLE N 324 -640 348 -576 
            LINE N 64 -256 0 -256 
            RECTANGLE N 0 -268 64 -244 
            LINE N 64 -176 0 -176 
            RECTANGLE N 0 -188 64 -164 
            LINE N 656 -256 720 -256 
            RECTANGLE N 656 -268 720 -244 
            LINE N 656 -176 720 -176 
            RECTANGLE N 656 -188 720 -164 
            LINE N 304 -160 272 -128 
            LINE N 304 -160 336 -128 
            LINE N 304 -64 304 -128 
            LINE N 400 -64 400 -128 
            LINE N 336 -640 336 -576 
            LINE N 656 -496 720 -496 
            RECTANGLE N 656 -508 720 -484 
        END BLOCKDEF
        BEGIN BLOCKDEF "commit"
            TIMESTAMP 2003 11 28 23 15 52
            LINE N 64 96 0 96 
            RECTANGLE N 0 84 64 108 
            LINE N 544 96 608 96 
            LINE N 64 -288 0 -288 
            LINE N 64 -224 0 -224 
            RECTANGLE N 0 -236 64 -212 
            LINE N 64 -160 0 -160 
            RECTANGLE N 0 -172 64 -148 
            LINE N 64 -96 0 -96 
            RECTANGLE N 0 -108 64 -84 
            LINE N 64 -32 0 -32 
            RECTANGLE N 0 -44 64 -20 
            LINE N 64 32 0 32 
            RECTANGLE N 0 20 64 44 
            LINE N 544 -160 608 -160 
            LINE N 544 32 608 32 
            RECTANGLE N 544 20 608 44 
            LINE N 64 -352 0 -352 
            LINE N 544 -32 608 -32 
            RECTANGLE N 544 -108 608 -84 
            LINE N 544 -96 608 -96 
            LINE N 544 -352 608 -352 
            LINE N 544 -288 608 -288 
            LINE N 544 -224 608 -224 
            RECTANGLE N 544 -236 608 -212 
            RECTANGLE N 64 -384 544 208 
        END BLOCKDEF
        BEGIN BLOCKDEF "rob"
            TIMESTAMP 2003 11 28 23 16 4
            RECTANGLE N 64 -1024 656 48 
            LINE N 64 -512 0 -512 
            LINE N 64 -576 0 -576 
            LINE N 64 -816 0 -816 
            LINE N 64 -944 0 -944 
            LINE N 64 -880 0 -880 
            LINE N 64 -640 0 -640 
            RECTANGLE N 0 -652 64 -628 
            LINE N 64 -336 0 -336 
            RECTANGLE N 0 -348 64 -324 
            LINE N 656 -720 720 -720 
            LINE N 656 -592 720 -592 
            LINE N 656 -656 720 -656 
            LINE N 656 -272 720 -272 
            LINE N 656 -944 720 -944 
            LINE N 656 -528 720 -528 
            LINE N 656 -336 720 -336 
            RECTANGLE N 656 -348 720 -324 
            LINE N 656 -464 720 -464 
            RECTANGLE N 656 -476 720 -452 
            RECTANGLE N 548 -1088 572 -1024 
            LINE N 560 -1088 560 -1024 
            LINE N 448 -1088 448 -1024 
            LINE N 480 16 448 48 
            LINE N 480 16 512 48 
            LINE N 480 112 480 48 
            LINE N 576 112 576 48 
            LINE N 176 48 176 112 
            RECTANGLE N 164 48 188 112 
            LINE N 320 48 320 112 
            RECTANGLE N 308 48 332 112 
            LINE N 288 -1088 288 -1024 
            RECTANGLE N 276 -1088 300 -1024 
            LINE N 176 -1088 176 -1024 
            LINE N 656 -400 720 -400 
            RECTANGLE N 656 -412 720 -388 
            LINE N 656 -208 720 -208 
            RECTANGLE N 656 -220 720 -196 
            LINE N 64 -208 0 -208 
            RECTANGLE N 0 -220 64 -196 
            LINE N 64 -704 0 -704 
            RECTANGLE N 0 -716 64 -692 
            LINE N 656 -784 720 -784 
            RECTANGLE N 656 -796 720 -772 
            LINE N 656 -144 720 -144 
            LINE N 656 -80 720 -80 
            RECTANGLE N 656 -92 720 -68 
            LINE N 64 -80 0 -80 
            RECTANGLE N 0 -92 64 -68 
            LINE N 656 -16 720 -16 
            LINE N 64 -448 0 -448 
            LINE N 656 -880 720 -880 
            RECTANGLE N 656 -892 720 -868 
        END BLOCKDEF
        BEGIN BLOCKDEF "dmdb_commit"
            TIMESTAMP 2003 11 28 23 15 54
            LINE N 64 -416 0 -416 
            LINE N 752 -160 688 -160 
            RECTANGLE N 688 -172 752 -148 
            LINE N 64 -160 0 -160 
            RECTANGLE N 0 -172 64 -148 
            LINE N 64 -288 0 -288 
            RECTANGLE N 0 -300 64 -276 
            LINE N 64 -224 0 -224 
            RECTANGLE N 0 -236 64 -212 
            LINE N 64 -352 0 -352 
            RECTANGLE N 0 -364 64 -340 
            LINE N 752 -416 688 -416 
            LINE N 752 -288 688 -288 
            RECTANGLE N 688 -300 752 -276 
            LINE N 752 -352 688 -352 
            RECTANGLE N 688 -364 752 -340 
            LINE N 752 -224 688 -224 
            RECTANGLE N 688 -236 752 -212 
            RECTANGLE N 64 -512 688 -64 
            RECTANGLE N 372 -576 396 -512 
            LINE N 384 -576 384 -512 
            LINE N 224 -576 224 -512 
            LINE N 208 -96 176 -64 
            LINE N 208 -96 240 -64 
            LINE N 208 0 208 -64 
            RECTANGLE N 532 -576 556 -512 
            LINE N 544 -576 544 -512 
            LINE N 368 0 368 -64 
            LINE N 528 0 528 -64 
        END BLOCKDEF
        BEGIN BLOCKDEF "branchunit"
            TIMESTAMP 2003 11 27 22 38 9
            LINE N 304 32 368 32 
            LINE N 64 0 0 0 
            RECTANGLE N 0 -12 64 12 
            LINE N 64 64 0 64 
            RECTANGLE N 0 52 64 76 
            LINE N 64 -224 0 -224 
            RECTANGLE N 0 -236 64 -212 
            LINE N 64 -160 0 -160 
            RECTANGLE N 0 -172 64 -148 
            LINE N 64 -112 0 -112 
            RECTANGLE N 0 -124 64 -100 
            LINE N 64 -64 0 -64 
            RECTANGLE N 0 -76 64 -52 
            LINE N 304 -192 368 -192 
            RECTANGLE N 304 -204 368 -180 
            RECTANGLE N 64 -256 304 112 
        END BLOCKDEF
        BEGIN BLOCKDEF "branchpredictor"
            TIMESTAMP 2003 11 27 23 38 5
            LINE N 336 -384 400 -384 
            LINE N 64 -544 0 -544 
            LINE N 64 -496 0 -496 
            LINE N 272 -144 272 -192 
            LINE N 64 -352 0 -352 
            RECTANGLE N 0 -364 64 -340 
            LINE N 64 -448 0 -448 
            RECTANGLE N 0 -460 64 -436 
            LINE N 64 -304 0 -304 
            RECTANGLE N 0 -316 64 -292 
            LINE N 64 -256 0 -256 
            RECTANGLE N 0 -268 64 -244 
            RECTANGLE N 64 -576 336 -192 
            LINE N 144 -192 160 -208 
            LINE N 160 -208 176 -192 
            LINE N 160 -192 160 -144 
            LINE N 0 -400 64 -400 
        END BLOCKDEF
        BEGIN BLOCKDEF "branch_res_station"
            TIMESTAMP 2003 11 27 0 3 41
            RECTANGLE N 128 -896 528 -148 
            LINE N 128 -864 64 -864 
            LINE N 128 -800 64 -800 
            LINE N 512 -80 512 -144 
            LINE N 336 -960 336 -896 
            LINE N 192 -960 192 -896 
            LINE N 480 -960 480 -896 
            LINE N 128 -672 64 -672 
            RECTANGLE N 64 -684 128 -660 
            LINE N 128 -608 64 -608 
            RECTANGLE N 64 -620 128 -596 
            LINE N 128 -544 64 -544 
            RECTANGLE N 64 -556 128 -532 
            LINE N 128 -480 64 -480 
            RECTANGLE N 64 -492 128 -468 
            LINE N 128 -416 64 -416 
            RECTANGLE N 64 -428 128 -404 
            LINE N 128 -352 64 -352 
            RECTANGLE N 64 -364 128 -340 
            LINE N 128 -288 64 -288 
            RECTANGLE N 64 -300 128 -276 
            LINE N 592 -720 528 -720 
            RECTANGLE N 528 -732 592 -708 
            LINE N 528 -832 592 -832 
            LINE N 192 -80 192 -144 
            LINE N 528 -464 592 -464 
            RECTANGLE N 528 -476 592 -452 
            LINE N 528 -512 592 -512 
            RECTANGLE N 528 -524 592 -500 
            LINE N 528 -624 592 -624 
            RECTANGLE N 528 -636 592 -612 
            RECTANGLE N 336 -148 368 -80 
            LINE N 64 -736 128 -736 
            LINE N 592 -560 528 -560 
            RECTANGLE N 528 -572 592 -548 
            RECTANGLE N 64 -748 128 -724 
            LINE N 352 -80 352 -148 
            LINE N 592 -304 528 -304 
            LINE N 592 -240 528 -240 
            RECTANGLE N 528 -316 592 -292 
            LINE N 592 -368 528 -368 
        END BLOCKDEF
        BEGIN BLOCKDEF "m32x2"
            TIMESTAMP 2003 11 12 16 3 14
            LINE N 240 -48 176 -48 
            RECTANGLE N 176 -60 240 -36 
            LINE N 240 16 176 16 
            RECTANGLE N 176 4 240 28 
            LINE N 288 -176 288 -96 
            LINE N 336 -16 400 -16 
            RECTANGLE N 336 -28 400 -4 
            LINE N 240 -128 336 -64 
            LINE N 240 -128 240 100 
            LINE N 336 -64 336 28 
            LINE N 336 28 240 100 
        END BLOCKDEF
        BEGIN BLOCKDEF "branch_add"
            TIMESTAMP 2003 11 26 23 37 56
            LINE N 304 48 368 48 
            RECTANGLE N 304 36 368 60 
            LINE N 304 0 368 0 
            RECTANGLE N 304 -12 368 12 
            LINE N 64 80 0 80 
            RECTANGLE N 0 68 64 92 
            LINE N 64 128 0 128 
            RECTANGLE N 0 116 64 140 
            RECTANGLE N 64 -32 304 160 
        END BLOCKDEF
        BEGIN BLOCKDEF "zero256"
            TIMESTAMP 2003 11 25 10 49 26
            RECTANGLE N 64 -64 320 0 
            LINE N 320 -32 384 -32 
            RECTANGLE N 320 -44 384 -20 
        END BLOCKDEF
        BEGIN BLOCKDEF "reg_hi_lo"
            TIMESTAMP 2003 11 25 11 17 5
            RECTANGLE N 64 -320 288 -64 
            LINE N 64 -208 0 -208 
            LINE N 64 -112 0 -112 
            RECTANGLE N 0 -124 64 -100 
            LINE N 288 -160 352 -160 
            RECTANGLE N 288 -172 352 -148 
            LINE N 176 -64 176 -12 
            LINE N 152 -64 176 -88 
            LINE N 176 -88 200 -64 
            LINE N 224 -384 224 -320 
            LINE N 128 -384 128 -320 
        END BLOCKDEF
        BEGIN BLOCKDEF "m32x4"
            TIMESTAMP 2003 11 27 0 26 25
            LINE N 80 -272 16 -272 
            RECTANGLE N 16 -284 80 -260 
            LINE N 80 -208 16 -208 
            RECTANGLE N 16 -220 80 -196 
            LINE N 80 -144 16 -144 
            RECTANGLE N 16 -156 80 -132 
            LINE N 80 -80 16 -80 
            RECTANGLE N 16 -92 80 -68 
            RECTANGLE N 116 -400 140 -336 
            LINE N 176 -176 240 -176 
            RECTANGLE N 176 -188 240 -164 
            LINE N 80 -368 80 16 
            LINE N 176 -48 80 16 
            LINE N 176 -304 176 -48 
            LINE N 176 -304 80 -368 
            LINE N 128 -336 128 -400 
        END BLOCKDEF
        BEGIN BLOCKDEF "pcselect"
            TIMESTAMP 2003 11 29 10 37 36
            LINE N 64 -16 0 -16 
            LINE N 64 32 0 32 
            LINE N 64 -176 0 -176 
            LINE N 64 -112 0 -112 
            RECTANGLE N 0 -124 64 -100 
            LINE N 64 -64 0 -64 
            RECTANGLE N 0 -76 64 -52 
            LINE N 224 -144 288 -144 
            RECTANGLE N 224 -156 288 -132 
            RECTANGLE N 64 -192 224 48 
            RECTANGLE N 0 20 64 44 
        END BLOCKDEF
        BEGIN BLOCKDEF "memory_control"
            TIMESTAMP 2003 11 27 5 0 26
            RECTANGLE N 240 -832 592 0 
            LINE N 240 -800 176 -800 
            LINE N 240 -672 176 -672 
            LINE N 240 -544 176 -544 
            LINE N 240 -416 176 -416 
            LINE N 240 -288 176 -288 
            LINE N 240 -160 176 -160 
            RECTANGLE N 176 -172 240 -148 
            LINE N 240 -32 176 -32 
            RECTANGLE N 176 -44 240 -20 
            LINE N 592 -800 656 -800 
            LINE N 592 -736 656 -736 
            LINE N 592 -672 656 -672 
            LINE N 592 -608 656 -608 
            LINE N 592 -544 656 -544 
            LINE N 592 -480 656 -480 
            LINE N 592 -416 656 -416 
            LINE N 592 -352 656 -352 
            LINE N 592 -288 656 -288 
            RECTANGLE N 592 -300 656 -276 
            LINE N 592 -224 656 -224 
            RECTANGLE N 592 -236 656 -212 
            LINE N 592 -160 656 -160 
            RECTANGLE N 592 -172 656 -148 
            LINE N 592 -96 656 -96 
            RECTANGLE N 592 -108 656 -84 
            LINE N 592 -32 656 -32 
            RECTANGLE N 592 -44 656 -20 
        END BLOCKDEF
        BEGIN BLOCKDEF "load_buffer"
            TIMESTAMP 2003 11 28 8 8 45
            RECTANGLE N 48 -832 592 -320 
            LINE N 48 -720 -16 -720 
            LINE N 656 -656 592 -656 
            LINE N 48 -656 -16 -656 
            RECTANGLE N -16 -668 48 -644 
            LINE N 48 -592 -16 -592 
            RECTANGLE N -16 -604 48 -580 
            LINE N 48 -528 -16 -528 
            RECTANGLE N -16 -540 48 -516 
            LINE N 48 -464 -16 -464 
            RECTANGLE N -16 -476 48 -452 
            LINE N 656 -592 592 -592 
            RECTANGLE N 592 -604 656 -580 
            LINE N 592 -736 656 -736 
            LINE N 592 -496 656 -496 
            RECTANGLE N 592 -508 656 -484 
            LINE N 480 -320 480 -252 
            RECTANGLE N 308 -320 332 -256 
            LINE N 320 -320 320 -256 
            LINE N 160 -320 160 -252 
            LINE N 368 -832 336 -800 
            LINE N 304 -832 336 -800 
            LINE N 336 -832 336 -896 
            LINE N 432 -832 432 -896 
            LINE N 528 -832 528 -896 
            LINE N 208 -896 208 -832 
            RECTANGLE N 196 -896 220 -832 
            LINE N 112 -896 112 -832 
            LINE N 592 -432 656 -432 
        END BLOCKDEF
        BEGIN BLOCKDEF "readbuffer"
            TIMESTAMP 2003 11 27 23 38 10
            RECTANGLE N 64 -256 288 0 
            LINE N 64 -224 0 -224 
            LINE N 64 -160 0 -160 
            LINE N 64 -96 0 -96 
            LINE N 64 -32 0 -32 
            RECTANGLE N 0 -44 64 -20 
            LINE N 288 -160 352 -160 
            RECTANGLE N 288 -172 352 -148 
        END BLOCKDEF
        BEGIN BLOCKDEF "arbiter"
            TIMESTAMP 2003 11 27 7 42 50
            LINE N 560 -256 624 -256 
            LINE N 560 -192 624 -192 
            LINE N 64 -416 0 -416 
            LINE N 64 -672 0 -672 
            LINE N 64 -608 0 -608 
            LINE N 64 -544 0 -544 
            LINE N 64 -480 0 -480 
            LINE N 64 -352 0 -352 
            LINE N 64 -288 0 -288 
            LINE N 64 -224 0 -224 
            RECTANGLE N 0 -236 64 -212 
            LINE N 64 -160 0 -160 
            RECTANGLE N 0 -172 64 -148 
            LINE N 64 -96 0 -96 
            RECTANGLE N 0 -108 64 -84 
            LINE N 64 -32 0 -32 
            RECTANGLE N 0 -44 64 -20 
            LINE N 560 -672 624 -672 
            LINE N 560 -608 624 -608 
            LINE N 560 -544 624 -544 
            LINE N 560 -432 624 -432 
            RECTANGLE N 560 -444 624 -420 
            LINE N 560 -368 624 -368 
            RECTANGLE N 560 -380 624 -356 
            LINE N 560 -96 624 -96 
            RECTANGLE N 560 -108 624 -84 
            LINE N 560 -32 624 -32 
            RECTANGLE N 560 -44 624 -20 
            RECTANGLE N 64 -704 560 0 
        END BLOCKDEF
        BEGIN BLOCKDEF "and2"
            TIMESTAMP 2001 2 2 12 25 36
            LINE N 0 -64 64 -64 
            LINE N 0 -128 64 -128 
            LINE N 256 -96 192 -96 
            ARC N 96 -144 192 -48 144 -48 144 -144 
            LINE N 144 -48 64 -48 
            LINE N 64 -144 144 -144 
            LINE N 64 -48 64 -144 
        END BLOCKDEF
        BEGIN BLOCKDEF "and2b1"
            TIMESTAMP 2001 2 2 12 25 36
            LINE N 64 -48 64 -144 
            LINE N 64 -144 144 -144 
            LINE N 144 -48 64 -48 
            ARC N 96 -144 192 -48 144 -48 144 -144 
            LINE N 256 -96 192 -96 
            LINE N 0 -128 64 -128 
            LINE N 0 -64 40 -64 
            CIRCLE N 40 -76 64 -52 
        END BLOCKDEF
        BEGIN BLOCKDEF "store_buffer"
            TIMESTAMP 2003 11 27 23 38 11
            RECTANGLE N 48 -832 592 -240 
            LINE N 48 -736 -16 -736 
            LINE N 48 -672 -16 -672 
            RECTANGLE N -16 -684 48 -660 
            LINE N 48 -608 -16 -608 
            RECTANGLE N -16 -620 48 -596 
            LINE N 48 -544 -16 -544 
            RECTANGLE N -16 -556 48 -532 
            LINE N 48 -480 -16 -480 
            RECTANGLE N -16 -492 48 -468 
            LINE N 48 -416 -16 -416 
            RECTANGLE N -16 -428 48 -404 
            LINE N 48 -352 -16 -352 
            RECTANGLE N -16 -364 48 -340 
            LINE N 592 -736 656 -736 
            LINE N 592 -544 656 -544 
            RECTANGLE N 592 -556 656 -532 
            LINE N 368 -832 336 -800 
            LINE N 304 -832 336 -800 
            LINE N 336 -832 336 -896 
            LINE N 432 -832 432 -896 
            LINE N 528 -832 528 -896 
            LINE N 480 -240 480 -172 
            RECTANGLE N 308 -240 332 -176 
            LINE N 320 -240 320 -176 
            LINE N 160 -240 160 -172 
            LINE N 208 -896 208 -832 
            RECTANGLE N 196 -896 220 -832 
            LINE N 112 -896 112 -832 
        END BLOCKDEF
        BEGIN BLOCKDEF "memio"
            TIMESTAMP 2003 11 27 9 55 24
            LINE N 208 -288 144 -288 
            LINE N 208 -192 144 -192 
            RECTANGLE N 144 -204 208 -180 
            LINE N 208 -128 144 -128 
            RECTANGLE N 144 -140 208 -116 
            LINE N 208 -80 144 -80 
            RECTANGLE N 144 -92 208 -68 
            LINE N 464 -272 528 -272 
            RECTANGLE N 464 -284 528 -260 
            LINE N 464 -144 528 -144 
            RECTANGLE N 464 -156 528 -132 
            LINE N 320 -4 348 -48 
            LINE N 348 -48 380 -4 
            RECTANGLE N 208 -352 464 0 
            RECTANGLE N 144 -44 208 -20 
            LINE N 208 -32 144 -32 
        END BLOCKDEF
        BEGIN BLOCKDEF "inv"
            TIMESTAMP 2001 2 2 12 25 36
            LINE N 0 -32 64 -32 
            LINE N 224 -32 160 -32 
            LINE N 64 -64 128 -32 
            LINE N 128 -32 64 0 
            LINE N 64 0 64 -64 
            CIRCLE N 128 -48 160 -16 
        END BLOCKDEF
        BEGIN BLOCKDEF "nor3"
            TIMESTAMP 2001 2 2 12 25 36
            LINE N 0 -64 48 -64 
            LINE N 0 -128 72 -128 
            LINE N 0 -192 48 -192 
            LINE N 256 -128 216 -128 
            CIRCLE N 192 -140 216 -116 
            LINE N 48 -64 48 -80 
            LINE N 48 -192 48 -176 
            LINE N 112 -80 48 -80 
            LINE N 112 -176 48 -176 
            ARC N -40 -184 72 -72 48 -80 48 -176 
            ARC N 28 -256 204 -80 112 -80 192 -128 
            ARC N 28 -176 204 0 192 -128 112 -176 
        END BLOCKDEF
        BEGIN BLOCKDEF "rom"
            TIMESTAMP 2003 11 27 5 28 38
            RECTANGLE N 64 -64 432 0 
            LINE N 64 -32 0 -32 
            RECTANGLE N 0 -44 64 -20 
            LINE N 432 -32 496 -32 
            RECTANGLE N 432 -44 496 -20 
        END BLOCKDEF
        BEGIN BLOCK "XLXI_2" "ireg"
            PIN "clk" "CLK"
            PIN "rst" "RST"
            PIN "we" "VCC"
            PIN "instrIN(31:0)" "Corona(31:0)"
            PIN "addrIN(31:0)" "pc_addrOUT(31:0)"
            PIN "instrOUT(31:0)" "instrOUT(31:0)"
            PIN "addrOUT(31:0)" "addrOUT(31:0)"
        END BLOCK
        BEGIN BLOCK "my_dmdb_dispatch" "dmdb_dispatch"
            PIN "clk" "CLK"
            PIN "issue" "dispatch_robIssue"
            PIN "instr(31:0)" "instrOUT(31:0)"
            PIN "addr(31:0)" "addrOUT(31:0)"
            PIN "cycle_count(63:0)" "cycle_count(63:0)"
        END BLOCK
        BEGIN BLOCK "my_cdb" "cdb"
            PIN "mult_req" "GND"
            PIN "load_req" "XLXN_1419"
            PIN "alu_req" "XLXN_73"
            PIN "clk" "CLK"
            PIN "rst" "RST"
            PIN "mult_din(132:0)" "zeroes(132:0)"
            PIN "load_din(68:0)" "XLXN_1720(68:0)"
            PIN "alu_din(100:0)" "XLXN_74(100:0)"
            PIN "mult_granted"
            PIN "load_granted" "XLXN_161"
            PIN "alu_granted" "XLXN_75"
            PIN "dout_en" "cdb_dout_en"
            PIN "dout(132:0)" "cdb_dout(132:0)"
            PIN "store_req" "store_buffer_req_bus"
            PIN "store_din(68:0)" "XLXN_1729(68:0)"
            PIN "store_granted" "XLXN_1727"
            PIN "branch_din(100:0)" "XLXN_876(100:0)"
            PIN "branch_granted" "XLXN_830"
            PIN "branch_req" "XLXN_828"
        END BLOCK
        BEGIN BLOCK "my_dispatch" "dispatch"
            PIN "stall" "GND"
            PIN "robFull" "robFull"
            PIN "brnchFull" "branchFull"
            PIN "aluFull" "aluFull"
            PIN "mulDivFull" "GND"
            PIN "lwFull" "lwFull"
            PIN "swFull" "swFull"
            PIN "rsHReady" "rsHReady"
            PIN "rtHReady" "rtHReady"
            PIN "addr(31:0)" "addrOUT(31:0)"
            PIN "instr(31:0)" "instrOUT(31:0)"
            PIN "rsReorder(4:0)" "regStatus_rsReorder(4:0)"
            PIN "rtReorder(4:0)" "regStatus_rtReorder(4:0)"
            PIN "rsData(31:0)" "regfile_rsData(31:0)"
            PIN "rtData(31:0)" "regfile_rtData(31:0)"
            PIN "rsHValue(31:0)" "rob_readValueOUT1(31:0)"
            PIN "rtHValue(31:0)" "rob_readValueOUT2(31:0)"
            PIN "ROBEntryAlloc(4:0)" "rob_issuePtr(4:0)"
            PIN "robIssue" "dispatch_robIssue"
            PIN "regStatIssue" "dispatch_regStatIssue"
            PIN "brnchIssue" "dispatch_branchIssue"
            PIN "aluIssue" "dispatch_aluIssue"
            PIN "mulDivIssue" "XLXN_332"
            PIN "lwIssue" "dispatch_lwIssue"
            PIN "swIssue" "dispatch_swIssue"
            PIN "RSBusy" "dispatch_RSBusy"
            PIN "rs(5:0)" "dispatch_rs(5:0)"
            PIN "rt(4:0)" "dispatch_rt(4:0)"
            PIN "rd(4:0)" "dispatch_rd(4:0)"
            PIN "writeReg(5:0)" "dispatch_writeReg(5:0)"
            PIN "writeRegROBEntry(4:0)" "dispatch_writeRegROBEntry(4:0)"
            PIN "RSVj(31:0)" "dispatch_RSVj(31:0)"
            PIN "RSVk(31:0)" "dispatch_RSVk(31:0)"
            PIN "RSQj(4:0)" "dispatch_RSQj(4:0)"
            PIN "RSQk(4:0)" "dispatch_RSQk(4:0)"
            PIN "RSAddr(31:0)" "dispatch_RSAddr(31:0)"
            PIN "rsH(4:0)" "dispatch_rsH(4:0)"
            PIN "rtH(4:0)" "dispatch_rtH(4:0)"
            PIN "aluOp(5:0)" "dispatch_aluOp(5:0)"
            PIN "cdb_en" "cdb_dout_en"
            PIN "cdb_in(68:0)" "cdb_dout(68:0)"
            PIN "ROBEntryReady" "dispatch_ROBEntryReady"
            PIN "branchOp(1:0)" "dispatch_branchOp(1:0)"
            PIN "mulDivOp(2:0)" "XLXN_1684(2:0)"
            PIN "jrStall" "dispatch_jrStall"
        END BLOCK
        BEGIN BLOCK "my_regfile" "regfile"
            PIN "RegWrite" "regFileCommit"
            PIN "rst" "RST"
            PIN "ReadRegister1(4:0)" "dispatch_rs(4:0)"
            PIN "ReadRegister2(4:0)" "dispatch_rt(4:0)"
            PIN "WriteRegister(4:0)" "rob_destOUT(4:0)"
            PIN "WriteData(31:0)" "rob_valueOUT(31:0)"
            PIN "ReadData1(31:0)" "regfile_rsData_pre(31:0)"
            PIN "ReadData2(31:0)" "regfile_rtData(31:0)"
            PIN "clk" "CLK"
        END BLOCK
        BEGIN BLOCK "XLXI_120" "m32x2"
            PIN "in0(31:0)" "XLXN_1375(31:0)"
            PIN "in1(31:0)" "XLXN_1388(31:0)"
            PIN "sel" "pc_addrOUT(31)"
            PIN "out0(31:0)" "Corona(31:0)"
        END BLOCK
        BEGIN BLOCK "my_branch_res_station" "branch_res_station"
            PIN "issue" "dispatch_branchIssue"
            PIN "cdb_en" "cdb_dout_en"
            PIN "bus_granted" "XLXN_830"
            PIN "clk" "CLK"
            PIN "rst" "RST"
            PIN "flush" "rollback"
            PIN "Vj_in(31:0)" "dispatch_RSVj(31:0)"
            PIN "Vk_in(31:0)" "dispatch_RSVk(31:0)"
            PIN "Qj_in(4:0)" "dispatch_RSQj(4:0)"
            PIN "Qk_in(4:0)" "dispatch_RSQk(4:0)"
            PIN "inst_in(31:0)" "instrOUT(31:0)"
            PIN "issued_to_in(4:0)" "dispatch_writeRegROBEntry(4:0)"
            PIN "cdb_in(36:0)" "cdb_dout(36:0)"
            PIN "branch_result(31:0)" "targetAddr(31:0)"
            PIN "full" "branchFull"
            PIN "req_bus" "XLXN_828"
            PIN "rs(31:0)" "XLXN_1130(31:0)"
            PIN "rt(31:0)" "XLXN_1129(31:0)"
            PIN "inst_out(31:0)" "XLXN_1127(31:0)"
            PIN "cdb_out(100:0)" "XLXN_876(100:0)"
            PIN "addr_in(31:0)" "addrOUT(31:0)"
            PIN "addr_out(31:0)" "XLXN_1128(31:0)"
            PIN "orangina(31:0)" "orangina(31:0)"
            PIN "can_opener" "can_opener"
            PIN "airplane" "airplane"
        END BLOCK
        BEGIN BLOCK "my_HI_LO" "reg_hi_lo"
            PIN "ReadRegister" "instrOUT(1)"
            PIN "WriteData(63:0)" "rob_valueOUT(63:0)"
            PIN "ReadData(31:0)"
            PIN "clk" "CLK"
            PIN "RegWrite" "regFileCommit"
            PIN "rst" "RST"
        END BLOCK
        BEGIN BLOCK "my_reg_status" "reg_status"
            PIN "issue" "dispatch_regStatIssue"
            PIN "result_wr" "regStatCommit"
            PIN "dest_reg_no(5:0)" "dispatch_writeReg(5:0)"
            PIN "issued_to(4:0)" "dispatch_writeRegROBEntry(4:0)"
            PIN "result_wr_reg_no(5:0)" "rob_destOUT(5:0)"
            PIN "j_reg_no(5:0)" "dispatch_rs(5:0)"
            PIN "k_reg_no(4:0)" "dispatch_rt(4:0)"
            PIN "j_status(4:0)" "regStatus_rsReorder(4:0)"
            PIN "k_status(4:0)" "regStatus_rtReorder(4:0)"
            PIN "clk" "CLK"
            PIN "rst" "RST"
            PIN "result_wr_status(4:0)" "dReorder(4:0)"
        END BLOCK
        BEGIN BLOCK "my_alu_rs" "alu_res_stations"
            PIN "issue" "dispatch_aluIssue"
            PIN "cdb_en" "cdb_dout_en"
            PIN "bus_granted" "XLXN_75"
            PIN "clk" "CLK"
            PIN "rst" "RST"
            PIN "flush" "rollback"
            PIN "Vj_in(31:0)" "dispatch_RSVj(31:0)"
            PIN "Vk_in(31:0)" "dispatch_RSVk(31:0)"
            PIN "Qj_in(4:0)" "dispatch_RSQj(4:0)"
            PIN "Qk_in(4:0)" "dispatch_RSQk(4:0)"
            PIN "alu_type_in(5:0)" "dispatch_aluOp(5:0)"
            PIN "issued_to_in(4:0)" "dispatch_writeRegROBEntry(4:0)"
            PIN "cdb_in(36:0)" "cdb_dout(36:0)"
            PIN "alu_result(31:0)" "XLXN_37(31:0)"
            PIN "full" "aluFull"
            PIN "req_bus" "XLXN_73"
            PIN "alu_inA(31:0)" "XLXN_34(31:0)"
            PIN "alu_inB(31:0)" "XLXN_35(31:0)"
            PIN "alu_type_out(5:0)" "XLXN_36(5:0)"
            PIN "cdb_out(100:0)" "XLXN_74(100:0)"
        END BLOCK
        BEGIN BLOCK "my_alu_ex" "alu_ex"
            PIN "din1(31:0)" "XLXN_34(31:0)"
            PIN "din2(31:0)" "XLXN_35(31:0)"
            PIN "alu_ctrl(5:0)" "XLXN_36(5:0)"
            PIN "dout(31:0)" "XLXN_37(31:0)"
        END BLOCK
        BEGIN BLOCK "XLXI_1" "pc"
            PIN "WE" "XLXN_1937"
            PIN "CLK" "CLK"
            PIN "RST" "RST"
            PIN "addrIN(31:0)" "mux_nextPC(31:0)"
            PIN "addrOUT(31:0)" "pc_addrOUT(31:0)"
        END BLOCK
        BEGIN BLOCK "XLXI_6" "adder"
            PIN "in0(31:0)" "XLXN_13(31:0)"
            PIN "in1(31:0)" "pc_addrOUT(31:0)"
            PIN "sum(31:0)" "adder_pc4(31:0)"
        END BLOCK
        BEGIN BLOCK "XLXI_28" "four"
            PIN "four(31:0)" "XLXN_13(31:0)"
        END BLOCK
        BEGIN BLOCK "instr_cache" "cache"
            PIN "clk" "CLK"
            PIN "rst" "RST"
            PIN "we_mem" "XLXN_1679"
            PIN "din(31:0)" "zeroes(31:0)"
            PIN "mem_req" "XLXN_1931"
            PIN "dout(31:0)" "XLXN_1375(31:0)"
            PIN "en" "XLXN_1928"
            PIN "write_if_cached" "GND"
            PIN "word_addr_read(22:0)" "pc_addrOUT(24:2)"
            PIN "word_addr_write(22:0)" "zeroes(22:0)"
            PIN "line_in(255:0)" "cache_line(255:0)"
            PIN "tag_index_mem(22:0)" "inst_mem_addr(22:0)"
        END BLOCK
        BEGIN BLOCK "my_counter64" "counter64"
            PIN "CLK" "CLK"
            PIN "ENABLE" "VCC"
            PIN "RESET" "RST"
            PIN "COUNT(63:0)" "cycle_count(63:0)"
        END BLOCK
        BEGIN BLOCK "RS_branchUnit" "branchunit"
            PIN "inst(31:0)" "XLXN_1127(31:0)"
            PIN "addr(31:0)" "XLXN_1128(31:0)"
            PIN "rs(31:0)" "XLXN_1129(31:0)"
            PIN "rt(31:0)" "XLXN_1130(31:0)"
            PIN "Qj(4:0)" "zeroes(4:0)"
            PIN "Qk(4:0)" "zeroes(4:0)"
            PIN "targetAddr(31:0)" "targetAddr(31:0)"
            PIN "stall"
        END BLOCK
        BEGIN BLOCK "XLXI_161" "m32x2"
            PIN "in0(31:0)" "regfile_rsData_pre(31:0)"
            PIN "in1(31:0)" "reg_HI_LO(31:0)"
            PIN "sel" "dispatch_rs(5)"
            PIN "out0(31:0)" "regfile_rsData(31:0)"
        END BLOCK
        BEGIN BLOCK "my_rob" "rob"
            PIN "swIN" "GND"
            PIN "CDB_en" "cdb_dout_en"
            PIN "storeAddrBus_en" "store_buffer_req_bus"
            PIN "isSpecBranchIN" "GND"
            PIN "rollback" "rollback"
            PIN "issue" "dispatch_robIssue"
            PIN "commit" "commit_robCommit"
            PIN "destIN(5:0)" "dispatch_writeReg(5:0)"
            PIN "CDBIN(68:0)" "cdb_dout(68:0)"
            PIN "loadAddress(22:0)" "load_buffer_addr_out(22:0)"
            PIN "storeAddrBus(28:0)" "store_buffer_addr_out(28:0)"
            PIN "readyOUT" "robReady"
            PIN "swOUT"
            PIN "validOUT" "XLXN_433"
            PIN "loadDataValid" "rob_loadDataValid"
            PIN "ROBFull" "robFull"
            PIN "isSpecBranchOUT"
            PIN "destOUT(22:0)" "rob_destOUT(22:0)"
            PIN "valueOUT(63:0)" "rob_valueOUT(63:0)"
            PIN "loadData(31:0)" "rob_loadData(31:0)"
            PIN "issue_ptr(4:0)" "rob_issuePtr(4:0)"
            PIN "clk" "CLK"
            PIN "rst" "RST"
            PIN "commit_ptr(4:0)" "rob_commitPtr(4:0)"
            PIN "readValueOUT1(31:0)" "rob_readValueOUT1(31:0)"
            PIN "readEntryNo1(4:0)" "dispatch_rsH(4:0)"
            PIN "addrIN(31:0)" "addrOUT(31:0)"
            PIN "addrOUT(31:0)" "rob_addrOUT(31:0)"
            PIN "readReadyOUT1" "rsHReady"
            PIN "readValueOUT2(31:0)" "rob_readValueOUT2(31:0)"
            PIN "readEntryNo2(4:0)" "dispatch_rtH(4:0)"
            PIN "readReadyOUT2" "rtHReady"
            PIN "readyIN" "dispatch_ROBEntryReady"
            PIN "readPredAddr(31:0)" "rob_readPredAddr(31:0)"
        END BLOCK
        BEGIN BLOCK "my_dmdb_commit" "dmdb_commit"
            PIN "commit" "commit_robCommit"
            PIN "addr(31:0)" "rob_addrOUT(31:0)"
            PIN "value(31:0)" "rob_valueOUT(31:0)"
            PIN "cycle_count(63:0)" "cycle_count(63:0)"
            PIN "cdb_en" "cdb_dout_en"
            PIN "issue" "dispatch_robIssue"
            PIN "cdb_in_VjVk(63:0)" "cdb_dout(132:69)"
            PIN "cdb_in_tag(4:0)" "cdb_dout(36:32)"
            PIN "commit_ptr(4:0)" "rob_commitPtr(4:0)"
            PIN "issue_ptr(4:0)" "rob_issuePtr(4:0)"
            PIN "rsValIN(31:0)" "dispatch_RSVj(31:0)"
            PIN "rtValIN(31:0)" "dispatch_RSVk(31:0)"
            PIN "instrIN(31:0)" "instrOUT(31:0)"
            PIN "clk" "CLK"
            PIN "commit_addr(31:0)" "dm_addr(31:0)"
            PIN "commit_instr(31:0)" "dm_instr(31:0)"
        END BLOCK
        BEGIN BLOCK "XLXI_78" "gnd"
            PIN "G" "GND"
        END BLOCK
        BEGIN BLOCK "XLXI_80" "vcc"
            PIN "P" "VCC"
        END BLOCK
        BEGIN BLOCK "XLXI_134" "zero256"
            PIN "z(255:0)" "zeroes(255:0)"
        END BLOCK
        BEGIN BLOCK "my_branchPredictor" "branchpredictor"
            PIN "branchResult" "airplane"
            PIN "update" "can_opener"
            PIN "clk" "CLK"
            PIN "rst" "RST"
            PIN "branchPC(31:0)" "pc_addrOUT(31:0)"
            PIN "updatePC(31:0)" "orangina(31:0)"
            PIN "notTakenPC(31:0)" "addr_notTaken(31:0)"
            PIN "takenPC(31:0)" "addr_taken(31:0)"
            PIN "predictedPC(31:0)" "XLXN_633(31:0)"
            PIN "inst(31:0)" "Corona(31:0)"
        END BLOCK
        BEGIN BLOCK "XLXI_167" "m32x4"
            PIN "in0(31:0)" "adder_pc4(31:0)"
            PIN "in1(31:0)" "XLXN_633(31:0)"
            PIN "in2(31:0)" "BU_targetAddr(31:0)"
            PIN "in3(31:0)" "targetAddr(31:0)"
            PIN "sel(1:0)" "pcMuxSel(1:0)"
            PIN "out0(31:0)" "mux_nextPC(31:0)"
        END BLOCK
        BEGIN BLOCK "my_branch_add" "branch_add"
            PIN "immed(15:0)" "Corona(15:0)"
            PIN "addr_in(31:0)" "pc_addrOUT(31:0)"
            PIN "addr_taken(31:0)" "addr_taken(31:0)"
            PIN "addr_notTaken(31:0)" "addr_notTaken(31:0)"
        END BLOCK
        BEGIN BLOCK "my_pcSelect" "pcselect"
            ATTR VeriModel "pcSelect"
            PIN "branchIssue" "dispatch_branchIssue"
            PIN "Qj(4:0)" "dispatch_RSQj(4:0)"
            PIN "Qk(4:0)" "dispatch_RSQk(4:0)"
            PIN "sel(1:0)" "pcMuxSel(1:0)"
            PIN "rollback" "rollback"
            PIN "branchOp(1:0)" "dispatch_branchOp(1:0)"
        END BLOCK
        BEGIN BLOCK "ID_branchUnit" "branchunit"
            PIN "inst(31:0)" "instrOUT(31:0)"
            PIN "addr(31:0)" "addrOUT(31:0)"
            PIN "rs(31:0)" "dispatch_RSVj(31:0)"
            PIN "rt(31:0)" "dispatch_RSVk(31:0)"
            PIN "Qj(4:0)" "dispatch_RSQj(4:0)"
            PIN "Qk(4:0)" "dispatch_RSQk(4:0)"
            PIN "targetAddr(31:0)" "BU_targetAddr(31:0)"
            PIN "stall" "branchUnit_stall"
        END BLOCK
        BEGIN BLOCK "my_memory_control" "memory_control"
            PIN "RESET" "mem_ctrl_rst"
            PIN "PROCCLK" "CLK"
            PIN "request" "mem_request"
            PIN "r_w" "mem_r_w"
            PIN "DRAMCLK" "DRAMCLK"
            PIN "address(22:0)" "mem_addr(22:0)"
            PIN "data_in(31:0)" "mem_data(31:0)"
            PIN "waitForMem" "waitForMem"
            PIN "CKE" "CKE"
            PIN "CS" "CS"
            PIN "RAS" "RAS"
            PIN "CAS" "CAS"
            PIN "WE" "WE"
            PIN "burstReadDone_reg" "burstReadDone"
            PIN "readBuffer_WE" "readBuffer_WE"
            PIN "data_out(31:0)"
            PIN "Addr(11:0)" "addr(11:0)"
            PIN "Ba(1:0)" "Ba(1:0)"
            PIN "DQM(1:0)" "DQM(1:0)"
            PIN "Data(31:0)" "mem_BiData(31:0)"
        END BLOCK
        BEGIN BLOCK "XLXI_229" "and2"
            PIN "I0" "inst_we_gate"
            PIN "I1" "burstReadDone"
            PIN "O" "XLXN_1679"
        END BLOCK
        BEGIN BLOCK "XLXI_233" "store_buffer"
            PIN "issue" "dispatch_swIssue"
            PIN "immed_in(15:0)" "dispatch_RSVk(15:0)"
            PIN "Vj_in(31:0)" "dispatch_RSVj(31:0)"
            PIN "Qj_in(4:0)" "dispatch_RSQj(4:0)"
            PIN "Vstore_in(31:0)" "dispatch_RSVstore(31:0)"
            PIN "Qstore_in(4:0)" "dispatch_RSQstore(4:0)"
            PIN "issued_to_in(4:0)" "dispatch_writeRegROBEntry(4:0)"
            PIN "full" "swFull"
            PIN "addr_out(28:0)" "store_buffer_addr_out(28:0)"
            PIN "clk" "CLK"
            PIN "rst" "RST"
            PIN "flush" "rollback"
            PIN "bus_granted" "XLXN_1727"
            PIN "req_bus" "store_buffer_req_bus"
            PIN "cdb_out(68:0)" "XLXN_1729(68:0)"
            PIN "cdb_en" "cdb_dout_en"
            PIN "cdb_in(36:0)" "cdb_dout(36:0)"
        END BLOCK
        BEGIN BLOCK "XLXI_232" "and2b1"
            PIN "I0" "use_memio"
            PIN "I1" "XLXN_1710"
            PIN "O" "data_req"
        END BLOCK
        BEGIN BLOCK "data_cache" "cache"
            PIN "clk" "CLK"
            PIN "rst" "RST"
            PIN "we_mem" "XLXN_1594"
            PIN "din(31:0)" "rob_valueOUT(31:0)"
            PIN "mem_req" "XLXN_1710"
            PIN "dout(31:0)" "XLXN_239(31:0)"
            PIN "en" "VCC"
            PIN "write_if_cached" "commit_writeCache"
            PIN "word_addr_read(22:0)" "load_buffer_addr_out(22:0)"
            PIN "word_addr_write(22:0)" "rob_destOUT(22:0)"
            PIN "line_in(255:0)" "cache_line(255:0)"
            PIN "tag_index_mem(22:0)" "data_mem_addr(22:0)"
        END BLOCK
        BEGIN BLOCK "XLXI_254" "m32x2"
            PIN "in0(31:0)" "XLXN_239(31:0)"
            PIN "in1(31:0)" "memio_dout(31:0)"
            PIN "sel" "use_memio"
            PIN "out0(31:0)" "XLXN_1926(31:0)"
        END BLOCK
        BEGIN BLOCK "XLXI_255" "and2"
            PIN "I0" "burstReadDone"
            PIN "I1" "data_we_gate"
            PIN "O" "XLXN_1594"
        END BLOCK
        BEGIN BLOCK "my_readBuffer" "readbuffer"
            PIN "RESET" "RST"
            PIN "WE" "readBuffer_WE"
            PIN "DRAMCLK" "DRAMCLK"
            PIN "dIn(31:0)" "mem_BiData(31:0)"
            PIN "dOut(255:0)" "cache_line(255:0)"
        END BLOCK
        BEGIN BLOCK "my_arbiter" "arbiter"
            PIN "inst_req" "inst_req"
            PIN "data_req" "data_req"
            PIN "WB_req" "GND"
            PIN "WB_full" "robFull"
            PIN "waitForMem" "waitForMem"
            PIN "CLK" "CLK"
            PIN "RESET" "RST"
            PIN "inst_addr(22:0)" "inst_mem_addr(22:0)"
            PIN "data_addr(22:0)" "data_mem_addr(22:0)"
            PIN "WB_addr(22:0)" "rob_destOUT(22:0)"
            PIN "WB_data(31:0)" "rob_valueOUT(31:0)"
            PIN "request" "mem_request"
            PIN "r_w" "mem_r_w"
            PIN "WB_granted" "arbiter_WB_granted"
            PIN "addr(22:0)" "mem_addr(22:0)"
            PIN "dataOut(31:0)" "mem_data(31:0)"
            PIN "CurState(3:0)"
            PIN "NextState(3:0)"
            PIN "inst_we_gate" "inst_we_gate"
            PIN "data_we_gate" "data_we_gate"
        END BLOCK
        BEGIN BLOCK "my_load_buffer" "load_buffer"
            PIN "issue" "dispatch_lwIssue"
            PIN "data_mem_req" "data_req"
            PIN "immed_in(15:0)" "dispatch_RSVk(15:0)"
            PIN "Vj_in(31:0)" "dispatch_RSVj(31:0)"
            PIN "Qj_in(4:0)" "dispatch_RSQj(4:0)"
            PIN "issued_to_in(4:0)" "dispatch_writeRegROBEntry(4:0)"
            PIN "data(31:0)" "XLXN_1925(31:0)"
            PIN "full" "lwFull"
            PIN "addr_out(22:0)" "load_buffer_addr_out(22:0)"
            PIN "bus_granted" "XLXN_161"
            PIN "req_bus" "XLXN_1419"
            PIN "cdb_out(68:0)" "XLXN_1720(68:0)"
            PIN "clk" "CLK"
            PIN "rst" "RST"
            PIN "flush" "rollback"
            PIN "cdb_en" "cdb_dout_en"
            PIN "cdb_in(36:0)" "cdb_dout(36:0)"
            PIN "memio_out" "use_memio"
        END BLOCK
        BEGIN BLOCK "XLXI_270" "m32x2"
            PIN "in0(31:0)" "XLXN_1926(31:0)"
            PIN "in1(31:0)" "rob_loadData(31:0)"
            PIN "sel" "rob_loadDataValid"
            PIN "out0(31:0)" "XLXN_1925(31:0)"
        END BLOCK
        BEGIN BLOCK "my_memio" "memio"
            PIN "rst" "RST"
            PIN "clk" "CLK"
            PIN "we" "use_memio"
            PIN "out_sel" "memio_outsel"
            PIN "addr(22:0)" "rob_destOUT(22:0)"
            PIN "din(31:0)" "rob_valueOUT(31:0)"
            PIN "in_bus(7:0)" "memio_in(7:0)"
            PIN "dout(31:0)" "memio_dout(31:0)"
            PIN "out_bus(31:0)" "memio_out(31:0)"
            PIN "en" "VCC"
            PIN "MEM_addr(22:0)" "rob_destOUT(22:0)"
        END BLOCK
        BEGIN BLOCK "XLXI_273" "and2b1"
            PIN "I0" "pc_addrOUT(31)"
            PIN "I1" "XLXN_1931"
            PIN "O" "inst_req"
        END BLOCK
        BEGIN BLOCK "my_commit" "commit"
            PIN "robHeadEntryReady" "robReady"
            PIN "rls" "rls"
            PIN "robHeadEntry(4:0)" "rob_commitPtr(4:0)"
            PIN "robHeadEntryDest(4:0)" "rob_destOUT(4:0)"
            PIN "robHeadEntryInstr(31:0)" "dm_instr(31:0)"
            PIN "robHeadEntryValue(31:0)" "rob_valueOUT(31:0)"
            PIN "writeRegROBEntry(4:0)" "dReorder(4:0)"
            PIN "predictedAddr(31:0)" "rob_readPredAddr(31:0)"
            PIN "writeRegBusy" "commit_writeRegBusy"
            PIN "regFileCommit" "regFileCommit"
            PIN "regStatCommit" "regStatCommit"
            PIN "robCommit" "commit_robCommit"
            PIN "rollBack" "commit_rollBack"
            PIN "regFileOut(31:0)" "commit_regFileOut(31:0)"
            PIN "writeReg(4:0)" "commit_writeReg(4:0)"
            PIN "stat_output(7:0)" "stat_output(7:0)"
        END BLOCK
        BEGIN BLOCK "XLXI_274" "inv"
            PIN "I" "dispatch_jrStall"
            PIN "O" "VCC"
        END BLOCK
        BEGIN BLOCK "XLXI_275" "nor3"
            PIN "I0" "dispatch_jrStall"
            PIN "I1" "branchUnit_stall"
            PIN "I2" "dispatch_RSBusy"
            PIN "O" "XLXN_1928"
        END BLOCK
        BEGIN BLOCK "XLXI_276" "inv"
            PIN "I" "dispatch_jrStall"
            PIN "O" "XLXN_1937"
        END BLOCK
        BEGIN BLOCK "XLXI_278" "rom"
            PIN "addr(4:0)" "pc_addrOUT(6:2)"
            PIN "instr(31:0)" "XLXN_1388(31:0)"
        END BLOCK
    END NETLIST
    BEGIN SHEET 1 7040 5440
        BEGIN DISPLAY 80 124 TEXT "CS152 Dream Team"
            FONT 64 "Arial"
        END DISPLAY
        BEGIN DISPLAY 192 204 TEXT "<[ Ozone ]>"
            FONT 64 "Arial"
        END DISPLAY
        BEGIN BRANCH "CLK"
            WIRE 3056 144 3136 144
            BEGIN DISPLAY 3056 144 ATTR "Name"
                ALIGNMENT SOFT-RIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "cycle_count(63:0)"
            WIRE 2496 400 2720 400
            WIRE 2720 400 3136 400
            BEGIN DISPLAY 2720 400 ATTR "Name"
                ALIGNMENT SOFT-BCENTER
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "cdb_dout(132:0)"
            WIRE 5760 5184 5760 5232
            WIRE 5760 5232 6160 5232
            WIRE 6160 5232 6800 5232
            WIRE 6320 464 6800 464
            WIRE 6800 464 6800 5232
            BEGIN DISPLAY 6160 5232 ATTR "Name"
                ALIGNMENT SOFT-BCENTER
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "cdb_dout_en"
            WIRE 5600 5184 5600 5312
            WIRE 5600 5312 5920 5312
            WIRE 5920 5312 6896 5312
            WIRE 5968 384 5968 496
            WIRE 5968 384 6896 384
            WIRE 6896 384 6896 5312
            BEGIN DISPLAY 5920 5312 ATTR "Name"
                ALIGNMENT SOFT-BCENTER
            END DISPLAY
        END BRANCH
        BEGIN INSTANCE "my_cdb" 2960 5120 R0
        END INSTANCE
        BEGIN BRANCH "CLK"
            WIRE 480 5008 576 5008
            BEGIN DISPLAY 480 5008 ATTR "Name"
                ALIGNMENT SOFT-RIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "RST"
            WIRE 480 5072 576 5072
            BEGIN DISPLAY 480 5072 ATTR "Name"
                ALIGNMENT SOFT-RIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "rob_valueOUT(63:0)"
            WIRE 5840 1696 5840 1952
            WIRE 5840 1952 5840 2416
            WIRE 5840 2416 5872 2416
            WIRE 5840 2416 5840 2864
            WIRE 5840 2864 6272 2864
            BEGIN DISPLAY 5840 1952 ATTR "Name"
                ALIGNMENT SOFT-TVCENTER
            END DISPLAY
        END BRANCH
        BEGIN INSTANCE "my_dispatch" 3296 2464 R0
        END INSTANCE
        BEGIN BRANCH "GND"
            WIRE 3168 896 3200 896
            WIRE 3200 896 3296 896
            WIRE 3168 896 3168 1216
            WIRE 3168 1216 3296 1216
            BEGIN DISPLAY 3200 896 ATTR "Name"
                ALIGNMENT SOFT-BCENTER
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "dispatch_RSBusy"
            WIRE 3984 1344 4048 1344
            BEGIN DISPLAY 4048 1344 ATTR "Name"
                ALIGNMENT SOFT-LEFT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "dispatch_swIssue"
            WIRE 3984 1280 4048 1280
            BEGIN DISPLAY 4048 1280 ATTR "Name"
                ALIGNMENT SOFT-LEFT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "dispatch_lwIssue"
            WIRE 3984 1216 4048 1216
            BEGIN DISPLAY 4048 1216 ATTR "Name"
                ALIGNMENT SOFT-LEFT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "XLXN_332"
            WIRE 3984 1152 4048 1152
        END BRANCH
        BEGIN BRANCH "dispatch_aluIssue"
            WIRE 3984 1088 4048 1088
            BEGIN DISPLAY 4048 1088 ATTR "Name"
                ALIGNMENT SOFT-LEFT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "dispatch_branchIssue"
            WIRE 3984 1024 4048 1024
            BEGIN DISPLAY 4048 1024 ATTR "Name"
                ALIGNMENT SOFT-LEFT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "dispatch_regStatIssue"
            WIRE 3984 960 4048 960
            BEGIN DISPLAY 4048 960 ATTR "Name"
                ALIGNMENT SOFT-LEFT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "dispatch_robIssue"
            WIRE 3984 896 4048 896
            BEGIN DISPLAY 4048 896 ATTR "Name"
                ALIGNMENT SOFT-LEFT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "CLK"
            WIRE 6240 2528 6240 2560
            BEGIN DISPLAY 6240 2560 ATTR "Name"
                ALIGNMENT SOFT-VRIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "RST"
            WIRE 6160 1936 6160 1968
            BEGIN DISPLAY 6160 1936 ATTR "Name"
                ALIGNMENT SOFT-VLEFT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "dispatch_rs(4:0)"
            WIRE 5984 2112 6016 2112
            BEGIN DISPLAY 5984 2112 ATTR "Name"
                ALIGNMENT SOFT-RIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "dispatch_rt(4:0)"
            WIRE 5984 2208 6016 2208
            BEGIN DISPLAY 5984 2208 ATTR "Name"
                ALIGNMENT SOFT-RIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "regfile_rsData(31:0)"
            WIRE 3248 1936 3296 1936
            BEGIN DISPLAY 3248 1936 ATTR "Name"
                ALIGNMENT SOFT-RIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "regfile_rtData(31:0)"
            WIRE 3248 2016 3296 2016
            BEGIN DISPLAY 3248 2016 ATTR "Name"
                ALIGNMENT SOFT-RIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "regStatus_rtReorder(4:0)"
            WIRE 3248 1856 3296 1856
            BEGIN DISPLAY 3248 1856 ATTR "Name"
                ALIGNMENT SOFT-RIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "regStatus_rsReorder(4:0)"
            WIRE 3248 1776 3296 1776
            BEGIN DISPLAY 3248 1776 ATTR "Name"
                ALIGNMENT SOFT-RIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "addrOUT(31:0)"
            WIRE 2784 1200 2912 1200
            WIRE 2912 1200 3024 1200
            WIRE 3024 1200 3024 1616
            WIRE 3024 1616 3296 1616
            WIRE 3024 336 3136 336
            WIRE 3024 336 3024 1200
            BEGIN DISPLAY 2912 1200 ATTR "Name"
                ALIGNMENT SOFT-BCENTER
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "instrOUT(31:0)"
            WIRE 2784 1264 2912 1264
            WIRE 2912 1264 2944 1264
            WIRE 2944 1264 2944 1696
            WIRE 2944 1696 3296 1696
            WIRE 2944 272 3136 272
            WIRE 2944 272 2944 1264
            BEGIN DISPLAY 2912 1264 ATTR "Name"
                ALIGNMENT SOFT-BCENTER
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "regfile_rsData_pre(31:0)"
            WIRE 6464 2160 6496 2160
            WIRE 6496 2160 6576 2160
            WIRE 6576 1968 6576 2160
            BEGIN DISPLAY 6496 2160 ATTR "Name"
                ALIGNMENT SOFT-BCENTER
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "robFull"
            WIRE 3248 976 3296 976
            BEGIN DISPLAY 3248 976 ATTR "Name"
                ALIGNMENT SOFT-RIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "regFileCommit"
            WIRE 6320 1936 6320 1968
            BEGIN DISPLAY 6320 1936 ATTR "Name"
                ALIGNMENT SOFT-VLEFT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "rob_readValueOUT1(31:0)"
            WIRE 3248 2096 3296 2096
            BEGIN DISPLAY 3248 2096 ATTR "Name"
                ALIGNMENT SOFT-RIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "rob_readValueOUT2(31:0)"
            WIRE 3248 2176 3296 2176
            BEGIN DISPLAY 3248 2176 ATTR "Name"
                ALIGNMENT SOFT-RIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "rsHReady"
            WIRE 3248 1456 3296 1456
            BEGIN DISPLAY 3248 1456 ATTR "Name"
                ALIGNMENT SOFT-RIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "rtHReady"
            WIRE 3248 1536 3296 1536
            BEGIN DISPLAY 3248 1536 ATTR "Name"
                ALIGNMENT SOFT-RIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "aluFull"
            WIRE 3248 1136 3296 1136
            BEGIN DISPLAY 3248 1136 ATTR "Name"
                ALIGNMENT SOFT-RIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "GND"
            WIRE 5344 4720 5344 4896
            BEGIN DISPLAY 5344 4720 ATTR "Name"
                ALIGNMENT SOFT-VLEFT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "zeroes(132:0)"
            WIRE 5504 4752 5504 4896
            BEGIN DISPLAY 5504 4752 ATTR "Name"
                ALIGNMENT SOFT-VLEFT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "RST"
            WIRE 3424 4048 3424 4112
            BEGIN DISPLAY 3424 4048 ATTR "Name"
                ALIGNMENT SOFT-VLEFT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "cdb_dout(36:0)"
            WIRE 3200 4048 3200 4112
            BEGIN DISPLAY 3200 4048 ATTR "Name"
                ALIGNMENT SOFT-VLEFT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "cdb_dout_en"
            WIRE 3104 4048 3104 4112
            BEGIN DISPLAY 3104 4048 ATTR "Name"
                ALIGNMENT SOFT-VLEFT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "rollback"
            WIRE 3520 4048 3520 4112
            BEGIN DISPLAY 3520 4048 ATTR "Name"
                ALIGNMENT SOFT-VLEFT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "XLXN_161"
            WIRE 2352 3968 2352 4896
        END BRANCH
        BEGIN INSTANCE "my_branch_res_station" 784 4800 R0
        END INSTANCE
        BEGIN BRANCH "RST"
            WIRE 976 3792 976 3840
            BEGIN DISPLAY 976 3792 ATTR "Name"
                ALIGNMENT SOFT-VLEFT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "CLK"
            WIRE 1120 3792 1120 3840
            BEGIN DISPLAY 1120 3792 ATTR "Name"
                ALIGNMENT SOFT-VLEFT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "rollback"
            WIRE 1264 3792 1264 3840
            BEGIN DISPLAY 1264 3792 ATTR "Name"
                ALIGNMENT SOFT-VLEFT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "XLXN_828"
            WIRE 976 4720 976 4896
        END BRANCH
        BEGIN BRANCH "XLXN_830"
            WIRE 1296 4720 1296 4896
        END BRANCH
        BEGIN BRANCH "XLXN_876(100:0)"
            WIRE 1136 4720 1136 4896
        END BRANCH
        BEGIN BRANCH "branchFull"
            WIRE 3248 1056 3296 1056
            BEGIN DISPLAY 3248 1056 ATTR "Name"
                ALIGNMENT SOFT-RIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "CLK"
            WIRE 432 480 592 480
        END BRANCH
        LINE N 592 320 592 1592 
        BEGIN BRANCH "dm_addr(31:0)"
            WIRE 384 352 464 352
            WIRE 464 352 592 352
            BEGIN DISPLAY 464 352 ATTR "Name"
                ALIGNMENT SOFT-BCENTER
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "dm_instr(31:0)"
            WIRE 368 416 448 416
            WIRE 448 416 592 416
            BEGIN DISPLAY 448 416 ATTR "Name"
                ALIGNMENT SOFT-BCENTER
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "rls"
            WIRE 432 544 592 544
        END BRANCH
        BEGIN BRANCH "RST"
            WIRE 432 608 592 608
        END BRANCH
        BEGIN BRANCH "memio_in(7:0)"
            WIRE 432 672 592 672
        END BRANCH
        BEGIN BRANCH "memio_outsel"
            WIRE 432 736 592 736
        END BRANCH
        BEGIN BRANCH "memio_out(31:0)"
            WIRE 432 800 592 800
        END BRANCH
        BEGIN BRANCH "stat_output(7:0)"
            WIRE 368 864 480 864
            WIRE 480 864 592 864
            BEGIN DISPLAY 480 864 ATTR "Name"
                ALIGNMENT SOFT-BCENTER
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "WE"
            WIRE 432 1248 592 1248
        END BRANCH
        BEGIN BRANCH "addr(11:0)"
            WIRE 432 1312 592 1312
        END BRANCH
        BEGIN BRANCH "CAS"
            WIRE 432 1184 592 1184
        END BRANCH
        BEGIN BRANCH "RAS"
            WIRE 432 1120 592 1120
        END BRANCH
        BEGIN BRANCH "CS"
            WIRE 432 1056 592 1056
        END BRANCH
        BEGIN BRANCH "CKE"
            WIRE 432 992 592 992
        END BRANCH
        BEGIN BRANCH "DRAMCLK"
            WIRE 432 928 592 928
        END BRANCH
        BEGIN BRANCH "Ba(1:0)"
            WIRE 432 1376 592 1376
        END BRANCH
        BEGIN BRANCH "DQM(1:0)"
            WIRE 432 1440 592 1440
        END BRANCH
        BEGIN BRANCH "mem_ctrl_rst"
            WIRE 432 1568 592 1568
        END BRANCH
        BEGIN BRANCH "mem_BiData(31:0)"
            WIRE 432 1504 592 1504
        END BRANCH
        LINE N 152 896 600 896 
        IOMARKER 432 480 "CLK" R180 28
        IOMARKER 384 352 "dm_addr(31:0)" R180 28
        IOMARKER 368 416 "dm_instr(31:0)" R180 28
        IOMARKER 432 544 "rls" R180 28
        IOMARKER 432 608 "RST" R180 28
        IOMARKER 432 672 "memio_in(7:0)" R180 28
        IOMARKER 432 736 "memio_outsel" R180 28
        IOMARKER 432 800 "memio_out(31:0)" R180 28
        IOMARKER 368 864 "stat_output(7:0)" R180 28
        IOMARKER 432 1248 "WE" R180 28
        IOMARKER 432 1312 "addr(11:0)" R180 28
        IOMARKER 432 1184 "CAS" R180 28
        IOMARKER 432 1120 "RAS" R180 28
        IOMARKER 432 1056 "CS" R180 28
        IOMARKER 432 992 "CKE" R180 28
        IOMARKER 432 928 "DRAMCLK" R180 28
        IOMARKER 432 1376 "Ba(1:0)" R180 28
        IOMARKER 432 1440 "DQM(1:0)" R180 28
        IOMARKER 432 1568 "mem_ctrl_rst" R180 28
        IOMARKER 432 1504 "mem_BiData(31:0)" R180 28
        BEGIN BRANCH "branchFull"
            WIRE 1376 3968 1424 3968
            BEGIN DISPLAY 1424 3968 ATTR "Name"
                ALIGNMENT SOFT-LEFT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "dispatch_branchIssue"
            WIRE 800 3936 848 3936
            BEGIN DISPLAY 800 3936 ATTR "Name"
                ALIGNMENT SOFT-RIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "cdb_dout_en"
            WIRE 800 4000 848 4000
            BEGIN DISPLAY 800 4000 ATTR "Name"
                ALIGNMENT SOFT-RIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "addrOUT(31:0)"
            WIRE 800 4064 848 4064
            BEGIN DISPLAY 800 4064 ATTR "Name"
                ALIGNMENT SOFT-RIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "dispatch_RSVj(31:0)"
            WIRE 800 4128 848 4128
            BEGIN DISPLAY 800 4128 ATTR "Name"
                ALIGNMENT SOFT-RIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "dispatch_RSVk(31:0)"
            WIRE 800 4192 848 4192
            BEGIN DISPLAY 800 4192 ATTR "Name"
                ALIGNMENT SOFT-RIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "dispatch_RSQj(4:0)"
            WIRE 800 4256 848 4256
            BEGIN DISPLAY 800 4256 ATTR "Name"
                ALIGNMENT SOFT-RIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "dispatch_RSQk(4:0)"
            WIRE 800 4320 848 4320
            BEGIN DISPLAY 800 4320 ATTR "Name"
                ALIGNMENT SOFT-RIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "instrOUT(31:0)"
            WIRE 800 4384 848 4384
            BEGIN DISPLAY 800 4384 ATTR "Name"
                ALIGNMENT SOFT-RIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "dispatch_writeRegROBEntry(4:0)"
            WIRE 800 4448 848 4448
            BEGIN DISPLAY 800 4448 ATTR "Name"
                ALIGNMENT SOFT-RIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "cdb_dout(36:0)"
            WIRE 800 4512 848 4512
            BEGIN DISPLAY 800 4512 ATTR "Name"
                ALIGNMENT SOFT-RIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "pc_addrOUT(31:0)"
            WIRE 1152 608 1312 608
            WIRE 1312 608 1504 608
            WIRE 1504 608 1680 608
            WIRE 1312 608 1312 1024
            WIRE 1312 1024 1312 1600
            WIRE 1312 1600 1360 1600
            WIRE 1312 1600 1312 1744
            WIRE 1312 1744 2352 1744
            WIRE 1312 1024 1360 1024
            WIRE 2352 1136 2352 1744
            WIRE 2352 1136 2448 1136
            BEGIN DISPLAY 1504 608 ATTR "Name"
                ALIGNMENT SOFT-BCENTER
            END DISPLAY
        END BRANCH
        BUSTAP 5872 2416 5968 2416
        BEGIN BRANCH "rob_valueOUT(31:0)"
            WIRE 5968 2416 6000 2416
            WIRE 6000 2416 6016 2416
            BEGIN DISPLAY 6000 2416 ATTR "Name"
                ALIGNMENT SOFT-BCENTER
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "RST"
            WIRE 6400 2528 6400 2560
            WIRE 6400 2560 6400 2592
            BEGIN DISPLAY 6400 2560 ATTR "Name"
                ALIGNMENT SOFT-TVCENTER
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "regFileCommit"
            WIRE 6496 2528 6496 2560
            WIRE 6496 2560 6496 2592
            BEGIN DISPLAY 6496 2560 ATTR "Name"
                ALIGNMENT SOFT-TVCENTER
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "CLK"
            WIRE 6448 2960 6448 2976
            BEGIN DISPLAY 6448 2976 ATTR "Name"
                ALIGNMENT SOFT-VRIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "instrOUT(1)"
            WIRE 6256 2768 6272 2768
            BEGIN DISPLAY 6256 2768 ATTR "Name"
                ALIGNMENT SOFT-RIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "XLXN_73"
            WIRE 4208 3744 4208 4896
        END BRANCH
        BEGIN BRANCH "XLXN_74(100:0)"
            WIRE 4368 3744 4368 4896
        END BRANCH
        BEGIN BRANCH "XLXN_75"
            WIRE 4528 3744 4528 4896
        END BRANCH
        BEGIN INSTANCE "my_reg_status" 5776 3680 R0
        END INSTANCE
        BEGIN BRANCH "dispatch_rs(5:0)"
            WIRE 5728 3424 5776 3424
            BEGIN DISPLAY 5728 3424 ATTR "Name"
                ALIGNMENT SOFT-RIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "dispatch_rt(4:0)"
            WIRE 5728 3504 5776 3504
            BEGIN DISPLAY 5728 3504 ATTR "Name"
                ALIGNMENT SOFT-RIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "regStatus_rsReorder(4:0)"
            WIRE 6496 3424 6624 3424
            WIRE 6624 3424 6624 3520
            BEGIN DISPLAY 6624 3520 ATTR "Name"
                ALIGNMENT SOFT-VRIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "regStatus_rtReorder(4:0)"
            WIRE 6496 3504 6544 3504
            WIRE 6544 3504 6544 3520
            BEGIN DISPLAY 6544 3520 ATTR "Name"
                ALIGNMENT SOFT-VRIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "CLK"
            WIRE 6080 3616 6080 3712
            BEGIN DISPLAY 6080 3712 ATTR "Name"
                ALIGNMENT SOFT-VRIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "RST"
            WIRE 6176 3616 6176 3712
            BEGIN DISPLAY 6176 3712 ATTR "Name"
                ALIGNMENT SOFT-VRIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "dReorder(4:0)"
            WIRE 6496 3184 6544 3184
            BEGIN DISPLAY 6544 3184 ATTR "Name"
                ALIGNMENT SOFT-LEFT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "dispatch_regStatIssue"
            WIRE 5728 3200 5776 3200
            BEGIN DISPLAY 5728 3200 ATTR "Name"
                ALIGNMENT SOFT-RIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "dispatch_writeReg(5:0)"
            WIRE 5728 3264 5776 3264
            BEGIN DISPLAY 5728 3264 ATTR "Name"
                ALIGNMENT SOFT-RIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "regStatCommit"
            WIRE 5984 2992 6016 2992
            WIRE 6016 2992 6016 3040
            BEGIN DISPLAY 5984 2992 ATTR "Name"
                ALIGNMENT SOFT-RIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "dispatch_writeRegROBEntry(4:0)"
            WIRE 5728 3328 5776 3328
            BEGIN DISPLAY 5728 3328 ATTR "Name"
                ALIGNMENT SOFT-RIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "XLXN_34(31:0)"
            WIRE 4704 3360 4992 3360
        END BRANCH
        BEGIN BRANCH "XLXN_35(31:0)"
            WIRE 4704 3440 4848 3440
            WIRE 4848 3440 4848 3552
            WIRE 4848 3552 4992 3552
        END BRANCH
        BEGIN BRANCH "XLXN_36(5:0)"
            WIRE 4704 3520 4752 3520
            WIRE 4752 3520 4752 3680
            WIRE 4752 3680 5120 3680
            WIRE 5120 3664 5120 3680
        END BRANCH
        BEGIN BRANCH "XLXN_37(31:0)"
            WIRE 4704 3216 5296 3216
            WIRE 5296 3216 5296 3456
            WIRE 5264 3456 5296 3456
        END BRANCH
        BEGIN INSTANCE "my_alu_rs" 4000 3904 R0
        END INSTANCE
        BEGIN INSTANCE "my_alu_ex" 4976 3568 R0
        END INSTANCE
        BEGIN BRANCH "cdb_dout(36:0)"
            WIRE 4240 2896 4240 2944
            BEGIN DISPLAY 4240 2896 ATTR "Name"
                ALIGNMENT SOFT-VLEFT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "cdb_dout_en"
            WIRE 4144 2896 4144 2944
            BEGIN DISPLAY 4144 2896 ATTR "Name"
                ALIGNMENT SOFT-VLEFT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "CLK"
            WIRE 4368 2896 4368 2944
            BEGIN DISPLAY 4368 2896 ATTR "Name"
                ALIGNMENT SOFT-VLEFT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "RST"
            WIRE 4464 2896 4464 2944
            BEGIN DISPLAY 4464 2896 ATTR "Name"
                ALIGNMENT SOFT-VLEFT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "rollback"
            WIRE 4560 2896 4560 2944
            BEGIN DISPLAY 4560 2896 ATTR "Name"
                ALIGNMENT SOFT-VLEFT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "dispatch_aluOp(5:0)"
            WIRE 3952 3504 4000 3504
            BEGIN DISPLAY 3952 3504 ATTR "Name"
                ALIGNMENT SOFT-RIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "dispatch_RSQk(4:0)"
            WIRE 3952 3440 4000 3440
            BEGIN DISPLAY 3952 3440 ATTR "Name"
                ALIGNMENT SOFT-RIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "dispatch_RSQj(4:0)"
            WIRE 3952 3376 4000 3376
            BEGIN DISPLAY 3952 3376 ATTR "Name"
                ALIGNMENT SOFT-RIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "dispatch_RSVk(31:0)"
            WIRE 3952 3312 4000 3312
            BEGIN DISPLAY 3952 3312 ATTR "Name"
                ALIGNMENT SOFT-RIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "dispatch_RSVj(31:0)"
            WIRE 3952 3248 4000 3248
            BEGIN DISPLAY 3952 3248 ATTR "Name"
                ALIGNMENT SOFT-RIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "dispatch_aluIssue"
            WIRE 3952 3184 4000 3184
            BEGIN DISPLAY 3952 3184 ATTR "Name"
                ALIGNMENT SOFT-RIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "aluFull"
            WIRE 4704 3104 4800 3104
            BEGIN DISPLAY 4800 3104 ATTR "Name"
                ALIGNMENT SOFT-LEFT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "dispatch_writeRegROBEntry(4:0)"
            WIRE 3952 3568 4000 3568
            BEGIN DISPLAY 3952 3568 ATTR "Name"
                ALIGNMENT SOFT-RIGHT
            END DISPLAY
        END BRANCH
        BEGIN INSTANCE "XLXI_1" 800 784 R0
        END INSTANCE
        BEGIN BRANCH "RST"
            WIRE 1024 400 1024 464
            BEGIN DISPLAY 1024 400 ATTR "Name"
                ALIGNMENT SOFT-VLEFT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "CLK"
            WIRE 992 848 992 896
            BEGIN DISPLAY 992 896 ATTR "Name"
                ALIGNMENT SOFT-VRIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "mux_nextPC(31:0)"
            WIRE 688 704 720 704
            WIRE 720 704 832 704
            BEGIN DISPLAY 720 704 ATTR "Name"
                ALIGNMENT SOFT-BCENTER
            END DISPLAY
        END BRANCH
        BEGIN INSTANCE "XLXI_6" 1568 416 R0
        END INSTANCE
        BEGIN BRANCH "XLXN_13(31:0)"
            WIRE 1616 368 1680 368
        END BRANCH
        BEGIN BRANCH "adder_pc4(31:0)"
            WIRE 1952 496 2000 496
            BEGIN DISPLAY 2000 496 ATTR "Name"
                ALIGNMENT SOFT-LEFT
            END DISPLAY
        END BRANCH
        BEGIN INSTANCE "XLXI_28" 1232 400 R0
        END INSTANCE
        BEGIN BRANCH "RST"
            WIRE 1808 1344 1808 1376
            WIRE 1808 1376 1808 1392
            BEGIN DISPLAY 1808 1376 ATTR "Name"
                ALIGNMENT SOFT-TVCENTER
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "CLK"
            WIRE 1872 1344 1872 1376
            WIRE 1872 1376 1872 1392
            BEGIN DISPLAY 1872 1376 ATTR "Name"
                ALIGNMENT SOFT-TVCENTER
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "zeroes(31:0)"
            WIRE 1632 1216 1680 1216
            BEGIN DISPLAY 1632 1216 ATTR "Name"
                ALIGNMENT SOFT-RIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "zeroes(22:0)"
            WIRE 1632 1088 1680 1088
            BEGIN DISPLAY 1632 1088 ATTR "Name"
                ALIGNMENT SOFT-RIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "pc_addrOUT(24:2)"
            WIRE 1456 1024 1504 1024
            WIRE 1504 1024 1680 1024
            BEGIN DISPLAY 1504 1024 ATTR "Name"
                ALIGNMENT SOFT-BCENTER
            END DISPLAY
        END BRANCH
        BEGIN INSTANCE "instr_cache" 1664 1328 R0
        END INSTANCE
        BEGIN BRANCH "GND"
            WIRE 1632 1152 1680 1152
            BEGIN DISPLAY 1632 1152 ATTR "Name"
                ALIGNMENT SOFT-RIGHT
            END DISPLAY
        END BRANCH
        BUSTAP 1360 1024 1456 1024
        BEGIN BRANCH "pc_addrOUT(6:2)"
            WIRE 1456 1600 1472 1600
            WIRE 1472 1600 1584 1600
            BEGIN DISPLAY 1472 1600 ATTR "Name"
                ALIGNMENT SOFT-BCENTER
            END DISPLAY
        END BRANCH
        BUSTAP 1360 1600 1456 1600
        INSTANCE "XLXI_120" 1984 1584 R0
        BEGIN BRANCH "XLXN_1375(31:0)"
            WIRE 2048 1200 2096 1200
            WIRE 2096 1200 2096 1536
            WIRE 2096 1536 2160 1536
        END BRANCH
        BEGIN INSTANCE "XLXI_2" 2448 1216 R0
        END INSTANCE
        BEGIN BRANCH "Corona(31:0)"
            WIRE 2384 1568 2416 1568
            WIRE 2416 1088 2448 1088
            WIRE 2416 1088 2416 1376
            WIRE 2416 1376 2416 1568
            BEGIN DISPLAY 2416 1376 ATTR "Name"
                ALIGNMENT SOFT-TVCENTER
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "RST"
            WIRE 2368 992 2448 992
            BEGIN DISPLAY 2368 992 ATTR "Name"
                ALIGNMENT SOFT-RIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "VCC"
            WIRE 2368 1024 2448 1024
        END BRANCH
        BUSTAP 5872 2320 5968 2320
        BEGIN BRANCH "rob_destOUT(4:0)"
            WIRE 5968 2320 5984 2320
            WIRE 5984 2320 6016 2320
            BEGIN DISPLAY 5984 2320 ATTR "Name"
                ALIGNMENT SOFT-BCENTER
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "rob_destOUT(22:0)"
            WIRE 5696 1696 5696 1968
            WIRE 5696 1968 5696 2320
            WIRE 5696 2320 5696 2464
            WIRE 5696 2320 5872 2320
            BEGIN DISPLAY 5696 1968 ATTR "Name"
                ALIGNMENT SOFT-TVCENTER
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "rob_destOUT(5:0)"
            WIRE 5696 2560 5696 2736
            WIRE 5696 2736 5696 2928
            WIRE 5696 2928 6112 2928
            WIRE 6112 2928 6112 3040
            BEGIN DISPLAY 5696 2736 ATTR "Name"
                ALIGNMENT SOFT-TVCENTER
            END DISPLAY
        END BRANCH
        BUSTAP 5696 2464 5696 2560
        BEGIN DISPLAY 1288 72 TEXT "temporary counter (until we add memio)"
            FONT 48 "Arial"
        END DISPLAY
        BEGIN BRANCH "CLK"
            WIRE 2608 1344 2608 1440
            BEGIN DISPLAY 2608 1440 ATTR "Name"
                ALIGNMENT SOFT-VRIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "XLXN_1388(31:0)"
            WIRE 2080 1600 2160 1600
        END BRANCH
        BEGIN BRANCH "pc_addrOUT(31)"
            WIRE 2128 992 2128 1024
            WIRE 2128 1024 2272 1024
            WIRE 2272 1024 2272 1248
            WIRE 2272 1248 2272 1408
            BEGIN DISPLAY 2272 1248 ATTR "Name"
                ALIGNMENT SOFT-TVCENTER
            END DISPLAY
        END BRANCH
        BEGIN DISPLAY 2176 744 TEXT "Instruction Fetch"
            FONT 64 "Arial"
        END DISPLAY
        BEGIN INSTANCE "my_dmdb_dispatch" 3136 432 R0
        END INSTANCE
        BEGIN INSTANCE "my_counter64" 2080 368 R0
        END INSTANCE
        BEGIN BRANCH "VCC"
            WIRE 2032 272 2080 272
            BEGIN DISPLAY 2032 272 ATTR "Name"
                ALIGNMENT SOFT-RIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "CLK"
            WIRE 2032 208 2080 208
            BEGIN DISPLAY 2032 208 ATTR "Name"
                ALIGNMENT SOFT-RIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "RST"
            WIRE 2048 336 2080 336
            BEGIN DISPLAY 2048 336 ATTR "Name"
                ALIGNMENT SOFT-RIGHT
            END DISPLAY
        END BRANCH
        BEGIN DISPLAY 4864 1708 TEXT Commit
            FONT 64 "Arial"
        END DISPLAY
        BEGIN BRANCH "targetAddr(31:0)"
            WIRE 1376 4080 1632 4080
            WIRE 1632 4080 1904 4080
            WIRE 1904 4080 1904 4208
            WIRE 1888 4208 1904 4208
            BEGIN DISPLAY 1632 4080 ATTR "Name"
                ALIGNMENT SOFT-BCENTER
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "airplane"
            WIRE 1376 4432 1408 4432
            BEGIN DISPLAY 1408 4432 ATTR "Name"
                ALIGNMENT SOFT-LEFT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "orangina(31:0)"
            WIRE 1376 4496 1408 4496
            BEGIN DISPLAY 1408 4496 ATTR "Name"
                ALIGNMENT SOFT-LEFT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "can_opener"
            WIRE 1376 4560 1408 4560
            BEGIN DISPLAY 1408 4560 ATTR "Name"
                ALIGNMENT SOFT-LEFT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "XLXN_1127(31:0)"
            WIRE 1376 4176 1520 4176
        END BRANCH
        BEGIN BRANCH "XLXN_1128(31:0)"
            WIRE 1376 4240 1520 4240
        END BRANCH
        BEGIN BRANCH "XLXN_1129(31:0)"
            WIRE 1376 4288 1520 4288
        END BRANCH
        BEGIN BRANCH "XLXN_1130(31:0)"
            WIRE 1376 4336 1520 4336
        END BRANCH
        BEGIN BRANCH "regfile_rtData(31:0)"
            WIRE 6464 2352 6496 2352
            WIRE 6496 2352 6544 2352
            BEGIN DISPLAY 6496 2352 ATTR "Name"
                ALIGNMENT SOFT-BCENTER
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "dispatch_rs(5)"
            WIRE 6384 1856 6432 1856
            WIRE 6432 1856 6448 1856
            BEGIN DISPLAY 6432 1856 ATTR "Name"
                ALIGNMENT SOFT-BCENTER
            END DISPLAY
        END BRANCH
        BEGIN INSTANCE "my_regfile" 6000 2400 R0
        END INSTANCE
        INSTANCE "XLXI_161" 6624 2144 R270
        BEGIN BRANCH "regfile_rsData(31:0)"
            WIRE 6592 1712 6608 1712
            WIRE 6608 1712 6608 1744
            BEGIN DISPLAY 6592 1712 ATTR "Name"
                ALIGNMENT SOFT-RIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "commit_robCommit"
            WIRE 5392 704 5520 704
            BEGIN DISPLAY 5392 704 ATTR "Name"
                ALIGNMENT SOFT-RIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "dispatch_robIssue"
            WIRE 5392 640 5520 640
            BEGIN DISPLAY 5392 640 ATTR "Name"
                ALIGNMENT SOFT-RIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "dispatch_rsH(4:0)"
            WIRE 5376 1376 5520 1376
            BEGIN DISPLAY 5376 1376 ATTR "Name"
                ALIGNMENT SOFT-RIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "rob_readValueOUT1(31:0)"
            WIRE 6240 1376 6304 1376
            BEGIN DISPLAY 6304 1376 ATTR "Name"
                ALIGNMENT SOFT-LEFT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "rob_commitPtr(4:0)"
            WIRE 6240 1184 6304 1184
            BEGIN DISPLAY 6304 1184 ATTR "Name"
                ALIGNMENT SOFT-LEFT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "rob_issuePtr(4:0)"
            WIRE 6240 1120 6304 1120
            BEGIN DISPLAY 6304 1120 ATTR "Name"
                ALIGNMENT SOFT-LEFT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "robFull"
            WIRE 6240 640 6304 640
            BEGIN DISPLAY 6304 640 ATTR "Name"
                ALIGNMENT SOFT-LEFT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "XLXN_433"
            WIRE 6240 928 6352 928
        END BRANCH
        BEGIN BRANCH "robReady"
            WIRE 6240 864 6304 864
            BEGIN DISPLAY 6304 864 ATTR "Name"
                ALIGNMENT SOFT-LEFT
            END DISPLAY
        END BRANCH
        BEGIN INSTANCE "my_rob" 5520 1584 R0
        END INSTANCE
        BEGIN BRANCH "rob_addrOUT(31:0)"
            WIRE 6240 800 6304 800
            BEGIN DISPLAY 6304 800 ATTR "Name"
                ALIGNMENT SOFT-LEFT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "rollback"
            WIRE 5456 768 5520 768
            BEGIN DISPLAY 5456 768 ATTR "Name"
                ALIGNMENT SOFT-RIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "CLK"
            WIRE 6000 1696 6000 1760
            BEGIN DISPLAY 6000 1760 ATTR "Name"
                ALIGNMENT SOFT-VRIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "RST"
            WIRE 6096 1696 6096 1760
            BEGIN DISPLAY 6096 1760 ATTR "Name"
                ALIGNMENT SOFT-VRIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "dispatch_rtH(4:0)"
            WIRE 5376 1504 5520 1504
            BEGIN DISPLAY 5376 1504 ATTR "Name"
                ALIGNMENT SOFT-RIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "rob_readValueOUT2(31:0)"
            WIRE 6240 1504 6304 1504
            BEGIN DISPLAY 6304 1504 ATTR "Name"
                ALIGNMENT SOFT-LEFT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "rsHReady"
            WIRE 6240 1440 6304 1440
            BEGIN DISPLAY 6304 1440 ATTR "Name"
                ALIGNMENT SOFT-LEFT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "rtHReady"
            WIRE 6240 1568 6304 1568
            BEGIN DISPLAY 6304 1568 ATTR "Name"
                ALIGNMENT SOFT-LEFT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "cdb_dout(68:0)"
            WIRE 6080 464 6080 496
            WIRE 6080 464 6176 464
            WIRE 6176 464 6224 464
            BEGIN DISPLAY 6176 464 ATTR "Name"
                ALIGNMENT SOFT-BCENTER
            END DISPLAY
        END BRANCH
        BUSTAP 6320 464 6224 464
        BEGIN INSTANCE "my_dmdb_commit" 4224 720 R0
        END INSTANCE
        BEGIN BRANCH "dispatch_robIssue"
            WIRE 4160 304 4224 304
            BEGIN DISPLAY 4160 304 ATTR "Name"
                ALIGNMENT SOFT-RIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "instrOUT(31:0)"
            WIRE 4160 368 4224 368
            BEGIN DISPLAY 4160 368 ATTR "Name"
                ALIGNMENT SOFT-RIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "dispatch_RSVj(31:0)"
            WIRE 4160 432 4224 432
            BEGIN DISPLAY 4160 432 ATTR "Name"
                ALIGNMENT SOFT-RIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "dispatch_RSVk(31:0)"
            WIRE 4160 496 4224 496
            BEGIN DISPLAY 4160 496 ATTR "Name"
                ALIGNMENT SOFT-RIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "rob_issuePtr(4:0)"
            WIRE 4160 560 4224 560
            BEGIN DISPLAY 4160 560 ATTR "Name"
                ALIGNMENT SOFT-RIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "cdb_dout_en"
            WIRE 4416 96 4448 96
            WIRE 4448 96 4448 144
            BEGIN DISPLAY 4416 96 ATTR "Name"
                ALIGNMENT SOFT-RIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "CLK"
            WIRE 4432 720 4432 784
            BEGIN DISPLAY 4432 784 ATTR "Name"
                ALIGNMENT SOFT-VRIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "dm_instr(31:0)"
            WIRE 4592 720 4592 768
            BEGIN DISPLAY 4592 768 ATTR "Name"
                ALIGNMENT SOFT-VRIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "dm_addr(31:0)"
            WIRE 4752 720 4752 768
            BEGIN DISPLAY 4752 768 ATTR "Name"
                ALIGNMENT SOFT-VRIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "commit_robCommit"
            WIRE 4976 304 5040 304
            BEGIN DISPLAY 5040 304 ATTR "Name"
                ALIGNMENT SOFT-LEFT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "rob_valueOUT(31:0)"
            WIRE 4976 368 5040 368
            BEGIN DISPLAY 5040 368 ATTR "Name"
                ALIGNMENT SOFT-LEFT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "rob_addrOUT(31:0)"
            WIRE 4976 432 5040 432
            BEGIN DISPLAY 5040 432 ATTR "Name"
                ALIGNMENT SOFT-LEFT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "cycle_count(63:0)"
            WIRE 4976 496 5040 496
            BEGIN DISPLAY 5040 496 ATTR "Name"
                ALIGNMENT SOFT-LEFT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "rob_commitPtr(4:0)"
            WIRE 4976 560 5040 560
            BEGIN DISPLAY 5040 560 ATTR "Name"
                ALIGNMENT SOFT-LEFT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "cdb_dout(36:32)"
            WIRE 4608 64 4672 64
            WIRE 4608 64 4608 144
            BEGIN DISPLAY 4672 64 ATTR "Name"
                ALIGNMENT SOFT-LEFT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "cdb_dout(132:69)"
            WIRE 4768 112 4768 144
            WIRE 4768 112 4832 112
            BEGIN DISPLAY 4832 112 ATTR "Name"
                ALIGNMENT SOFT-LEFT
            END DISPLAY
        END BRANCH
        BEGIN INSTANCE "RS_branchUnit" 1520 4400 R0
        END INSTANCE
        BEGIN BRANCH "zeroes(4:0)"
            WIRE 1488 4400 1520 4400
            BEGIN DISPLAY 1488 4400 ATTR "Name"
                ALIGNMENT SOFT-RIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "zeroes(4:0)"
            WIRE 1488 4464 1520 4464
            BEGIN DISPLAY 1488 4464 ATTR "Name"
                ALIGNMENT SOFT-RIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "rob_issuePtr(4:0)"
            WIRE 3248 2384 3296 2384
            BEGIN DISPLAY 3248 2384 ATTR "Name"
                ALIGNMENT SOFT-RIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "dispatch_writeReg(5:0)"
            WIRE 3984 2368 4080 2368
            BEGIN DISPLAY 4080 2368 ATTR "Name"
                ALIGNMENT SOFT-LEFT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "dispatch_writeRegROBEntry(4:0)"
            WIRE 3984 2432 4080 2432
            BEGIN DISPLAY 4080 2432 ATTR "Name"
                ALIGNMENT SOFT-LEFT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "cdb_dout_en"
            WIRE 3568 752 3568 800
            BEGIN DISPLAY 3568 752 ATTR "Name"
                ALIGNMENT SOFT-VLEFT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "cdb_dout(68:0)"
            WIRE 3664 752 3664 800
            BEGIN DISPLAY 3664 752 ATTR "Name"
                ALIGNMENT SOFT-VLEFT
            END DISPLAY
        END BRANCH
        BEGIN DISPLAY 3448 924 TEXT Dispatch/Issue
            FONT 64 "Arial"
        END DISPLAY
        BEGIN BRANCH "dispatch_writeReg(5:0)"
            WIRE 5440 944 5520 944
            BEGIN DISPLAY 5440 944 ATTR "Name"
                ALIGNMENT SOFT-RIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "addrOUT(31:0)"
            WIRE 5440 880 5520 880
            BEGIN DISPLAY 5440 880 ATTR "Name"
                ALIGNMENT SOFT-RIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "GND"
            WIRE 5440 1008 5520 1008
            WIRE 5440 1008 5440 1056
            WIRE 5440 1056 5440 1072
            WIRE 5440 1072 5520 1072
            BEGIN DISPLAY 5440 1056 ATTR "Name"
                ALIGNMENT SOFT-TVCENTER
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "dispatch_ROBEntryReady"
            WIRE 5440 1136 5520 1136
            BEGIN DISPLAY 5440 1136 ATTR "Name"
                ALIGNMENT SOFT-RIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "dispatch_rd(4:0)"
            WIRE 3984 1568 4048 1568
            BEGIN DISPLAY 4048 1568 ATTR "Name"
                ALIGNMENT SOFT-LEFT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "dispatch_rt(4:0)"
            WIRE 3984 1504 4048 1504
            BEGIN DISPLAY 4048 1504 ATTR "Name"
                ALIGNMENT SOFT-LEFT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "dispatch_rs(5:0)"
            WIRE 3984 1440 4048 1440
            BEGIN DISPLAY 4048 1440 ATTR "Name"
                ALIGNMENT SOFT-LEFT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "dispatch_RSVj(31:0)"
            WIRE 3984 1664 4048 1664
            BEGIN DISPLAY 4048 1664 ATTR "Name"
                ALIGNMENT SOFT-LEFT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "dispatch_RSVk(31:0)"
            WIRE 3984 1728 4048 1728
            BEGIN DISPLAY 4048 1728 ATTR "Name"
                ALIGNMENT SOFT-LEFT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "dispatch_RSQj(4:0)"
            WIRE 3984 1792 4048 1792
            BEGIN DISPLAY 4048 1792 ATTR "Name"
                ALIGNMENT SOFT-LEFT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "dispatch_RSQk(4:0)"
            WIRE 3984 1856 4048 1856
            BEGIN DISPLAY 4048 1856 ATTR "Name"
                ALIGNMENT SOFT-LEFT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "dispatch_rsH(4:0)"
            WIRE 3984 1984 4048 1984
            BEGIN DISPLAY 4048 1984 ATTR "Name"
                ALIGNMENT SOFT-LEFT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "dispatch_rtH(4:0)"
            WIRE 3984 2048 4048 2048
            BEGIN DISPLAY 4048 2048 ATTR "Name"
                ALIGNMENT SOFT-LEFT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "dispatch_RSAddr(31:0)"
            WIRE 3984 1920 4048 1920
            BEGIN DISPLAY 4048 1920 ATTR "Name"
                ALIGNMENT SOFT-LEFT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "dispatch_aluOp(5:0)"
            WIRE 3984 2208 4048 2208
            BEGIN DISPLAY 4048 2208 ATTR "Name"
                ALIGNMENT SOFT-LEFT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "dispatch_ROBEntryReady"
            WIRE 3984 2496 4080 2496
            BEGIN DISPLAY 4080 2496 ATTR "Name"
                ALIGNMENT SOFT-LEFT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "pcMuxSel(1:0)"
            WIRE 1904 2000 1984 2000
            WIRE 1984 2000 1984 2112
            WIRE 1984 2112 1984 2208
            WIRE 1984 2208 2768 2208
            WIRE 2768 2208 2768 2384
            BEGIN DISPLAY 1984 2112 ATTR "Name"
                ALIGNMENT SOFT-TVCENTER
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "dispatch_branchOp(1:0)"
            WIRE 3984 2144 4048 2144
            BEGIN DISPLAY 4048 2144 ATTR "Name"
                ALIGNMENT SOFT-LEFT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "CLK"
            WIRE 3328 4048 3328 4112
            BEGIN DISPLAY 3328 4048 ATTR "Name"
                ALIGNMENT SOFT-VLEFT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "XLXN_1419"
            WIRE 2032 3968 2032 4896
        END BRANCH
        INSTANCE "XLXI_78" 880 1520 R0
        BEGIN BRANCH "GND"
            WIRE 944 1328 944 1392
            BEGIN DISPLAY 944 1328 ATTR "Name"
                ALIGNMENT SOFT-VLEFT
            END DISPLAY
        END BRANCH
        INSTANCE "XLXI_80" 672 1328 R0
        BEGIN BRANCH "VCC"
            WIRE 736 1328 736 1456
            BEGIN DISPLAY 736 1456 ATTR "Name"
                ALIGNMENT SOFT-VRIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "zeroes(255:0)"
            WIRE 1024 1088 1088 1088
            BEGIN DISPLAY 1088 1088 ATTR "Name"
                ALIGNMENT SOFT-LEFT
            END DISPLAY
        END BRANCH
        BEGIN INSTANCE "XLXI_134" 640 1120 R0
        END INSTANCE
        BEGIN BRANCH "Corona(31:0)"
            WIRE 2016 2464 2032 2464
            BEGIN DISPLAY 2016 2464 ATTR "Name"
                ALIGNMENT SOFT-RIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "CLK"
            WIRE 2192 2720 2192 2752
            WIRE 2192 2752 2192 2768
            BEGIN DISPLAY 2192 2752 ATTR "Name"
                ALIGNMENT SOFT-TVCENTER
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "RST"
            WIRE 2304 2720 2304 2752
            WIRE 2304 2752 2304 2768
            BEGIN DISPLAY 2304 2752 ATTR "Name"
                ALIGNMENT SOFT-TVCENTER
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "pc_addrOUT(31:0)"
            WIRE 2016 2512 2032 2512
            BEGIN DISPLAY 2016 2512 ATTR "Name"
                ALIGNMENT SOFT-RIGHT
            END DISPLAY
        END BRANCH
        BEGIN INSTANCE "my_branchPredictor" 2032 2864 R0
        END INSTANCE
        BEGIN BRANCH "airplane"
            WIRE 2016 2320 2032 2320
            BEGIN DISPLAY 2016 2320 ATTR "Name"
                ALIGNMENT SOFT-RIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "can_opener"
            WIRE 2016 2368 2032 2368
            BEGIN DISPLAY 2016 2368 ATTR "Name"
                ALIGNMENT SOFT-RIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "orangina(31:0)"
            WIRE 2016 2416 2032 2416
            BEGIN DISPLAY 2016 2416 ATTR "Name"
                ALIGNMENT SOFT-RIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "XLXN_633(31:0)"
            WIRE 2432 2480 2464 2480
            WIRE 2464 2480 2464 2576
            WIRE 2464 2576 2656 2576
        END BRANCH
        BEGIN BRANCH "BU_targetAddr(31:0)"
            WIRE 2608 2640 2656 2640
            BEGIN DISPLAY 2608 2640 ATTR "Name"
                ALIGNMENT SOFT-RIGHT
            END DISPLAY
        END BRANCH
        INSTANCE "XLXI_167" 2640 2784 R0
        BEGIN BRANCH "targetAddr(31:0)"
            WIRE 2608 2704 2656 2704
            BEGIN DISPLAY 2608 2704 ATTR "Name"
                ALIGNMENT SOFT-RIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "mux_nextPC(31:0)"
            WIRE 2880 2608 2928 2608
            WIRE 2928 2560 2928 2608
            BEGIN DISPLAY 2928 2560 ATTR "Name"
                ALIGNMENT SOFT-VLEFT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "adder_pc4(31:0)"
            WIRE 2608 2512 2656 2512
            BEGIN DISPLAY 2608 2512 ATTR "Name"
                ALIGNMENT SOFT-RIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "pc_addrOUT(31:0)"
            WIRE 1440 2688 1456 2688
            BEGIN DISPLAY 1440 2688 ATTR "Name"
                ALIGNMENT SOFT-RIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "Corona(15:0)"
            WIRE 1440 2640 1456 2640
            BEGIN DISPLAY 1440 2640 ATTR "Name"
                ALIGNMENT SOFT-RIGHT
            END DISPLAY
        END BRANCH
        BEGIN INSTANCE "my_branch_add" 1456 2560 R0
        END INSTANCE
        BEGIN BRANCH "dispatch_branchIssue"
            WIRE 1600 1968 1616 1968
            BEGIN DISPLAY 1600 1968 ATTR "Name"
                ALIGNMENT SOFT-RIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "dispatch_RSQj(4:0)"
            WIRE 1600 2032 1616 2032
            BEGIN DISPLAY 1600 2032 ATTR "Name"
                ALIGNMENT SOFT-RIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "dispatch_RSQk(4:0)"
            WIRE 1600 2080 1616 2080
            BEGIN DISPLAY 1600 2080 ATTR "Name"
                ALIGNMENT SOFT-RIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "rollback"
            WIRE 1600 2128 1616 2128
            BEGIN DISPLAY 1600 2128 ATTR "Name"
                ALIGNMENT SOFT-RIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "dispatch_branchOp(1:0)"
            WIRE 1600 2176 1616 2176
            BEGIN DISPLAY 1600 2176 ATTR "Name"
                ALIGNMENT SOFT-RIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "instrOUT(31:0)"
            WIRE 2320 1824 2336 1824
            WIRE 2336 1824 2352 1824
            BEGIN DISPLAY 2320 1824 ATTR "Name"
                ALIGNMENT SOFT-RIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "addrOUT(31:0)"
            WIRE 2320 1888 2336 1888
            WIRE 2336 1888 2352 1888
            BEGIN DISPLAY 2320 1888 ATTR "Name"
                ALIGNMENT SOFT-RIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "dispatch_RSVj(31:0)"
            WIRE 2320 1936 2336 1936
            WIRE 2336 1936 2352 1936
            BEGIN DISPLAY 2320 1936 ATTR "Name"
                ALIGNMENT SOFT-RIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "dispatch_RSVk(31:0)"
            WIRE 2320 1984 2336 1984
            WIRE 2336 1984 2352 1984
            BEGIN DISPLAY 2320 1984 ATTR "Name"
                ALIGNMENT SOFT-RIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "dispatch_RSQj(4:0)"
            WIRE 2320 2048 2336 2048
            WIRE 2336 2048 2352 2048
            BEGIN DISPLAY 2320 2048 ATTR "Name"
                ALIGNMENT SOFT-RIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "dispatch_RSQk(4:0)"
            WIRE 2320 2112 2336 2112
            WIRE 2336 2112 2352 2112
            BEGIN DISPLAY 2320 2112 ATTR "Name"
                ALIGNMENT SOFT-RIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "branchUnit_stall"
            WIRE 2720 2080 2736 2080
            WIRE 2736 2080 2768 2080
            BEGIN DISPLAY 2736 2080 ATTR "Name"
                ALIGNMENT SOFT-BCENTER
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "BU_targetAddr(31:0)"
            WIRE 2720 1856 2752 1856
            WIRE 2752 1856 2768 1856
            BEGIN DISPLAY 2752 1856 ATTR "Name"
                ALIGNMENT SOFT-BCENTER
            END DISPLAY
        END BRANCH
        BEGIN INSTANCE "my_memory_control" 48 2560 R0
        END INSTANCE
        BEGIN BRANCH "WE"
            WIRE 704 2080 720 2080
            BEGIN DISPLAY 720 2080 ATTR "Name"
                ALIGNMENT SOFT-LEFT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "CAS"
            WIRE 704 2016 720 2016
            BEGIN DISPLAY 720 2016 ATTR "Name"
                ALIGNMENT SOFT-LEFT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "RAS"
            WIRE 704 1952 720 1952
            BEGIN DISPLAY 720 1952 ATTR "Name"
                ALIGNMENT SOFT-LEFT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "CS"
            WIRE 704 1888 720 1888
            BEGIN DISPLAY 720 1888 ATTR "Name"
                ALIGNMENT SOFT-LEFT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "CKE"
            WIRE 704 1824 720 1824
            BEGIN DISPLAY 720 1824 ATTR "Name"
                ALIGNMENT SOFT-LEFT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "addr(11:0)"
            WIRE 704 2336 736 2336
            BEGIN DISPLAY 736 2336 ATTR "Name"
                ALIGNMENT SOFT-LEFT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "Ba(1:0)"
            WIRE 704 2400 736 2400
            BEGIN DISPLAY 736 2400 ATTR "Name"
                ALIGNMENT SOFT-LEFT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "DQM(1:0)"
            WIRE 704 2464 736 2464
            BEGIN DISPLAY 736 2464 ATTR "Name"
                ALIGNMENT SOFT-LEFT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "mem_ctrl_rst"
            WIRE 208 1760 224 1760
            BEGIN DISPLAY 208 1760 ATTR "Name"
                ALIGNMENT SOFT-RIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "CLK"
            WIRE 208 1888 224 1888
            BEGIN DISPLAY 208 1888 ATTR "Name"
                ALIGNMENT SOFT-RIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "readBuffer_WE"
            WIRE 704 2208 816 2208
            WIRE 816 2208 816 2400
            WIRE 816 2400 944 2400
            BEGIN DISPLAY 816 2208 ATTR "Name"
                ALIGNMENT SOFT-BCENTER
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "burstReadDone"
            WIRE 704 2144 736 2144
            BEGIN DISPLAY 736 2144 ATTR "Name"
                ALIGNMENT SOFT-LEFT
            END DISPLAY
        END BRANCH
        BEGIN DISPLAY 1604 2272 TEXT "Branch Prediction"
            FONT 64 "Arial"
        END DISPLAY
        BEGIN BRANCH "XLXN_1679"
            WIRE 1824 832 1824 896
        END BRANCH
        INSTANCE "XLXI_229" 1568 928 R0
        BEGIN BRANCH "burstReadDone"
            WIRE 1536 800 1568 800
            BEGIN DISPLAY 1536 800 ATTR "Name"
                ALIGNMENT SOFT-RIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "inst_we_gate"
            WIRE 1536 864 1568 864
            BEGIN DISPLAY 1536 864 ATTR "Name"
                ALIGNMENT SOFT-RIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "cache_line(255:0)"
            WIRE 1904 864 1904 896
            BEGIN DISPLAY 1904 864 ATTR "Name"
                ALIGNMENT SOFT-VLEFT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "XLXN_1684(2:0)"
            WIRE 3984 2272 4048 2272
        END BRANCH
        BEGIN BRANCH "DRAMCLK"
            WIRE 192 2272 224 2272
            BEGIN DISPLAY 192 2272 ATTR "Name"
                ALIGNMENT SOFT-RIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "mem_addr(22:0)"
            WIRE 192 2400 224 2400
            BEGIN DISPLAY 192 2400 ATTR "Name"
                ALIGNMENT SOFT-RIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "mem_data(31:0)"
            WIRE 192 2528 224 2528
            BEGIN DISPLAY 192 2528 ATTR "Name"
                ALIGNMENT SOFT-RIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "mem_r_w"
            WIRE 192 2144 224 2144
            BEGIN DISPLAY 192 2144 ATTR "Name"
                ALIGNMENT SOFT-RIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "mem_request"
            WIRE 192 2016 224 2016
            BEGIN DISPLAY 192 2016 ATTR "Name"
                ALIGNMENT SOFT-RIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "lwFull"
            WIRE 3248 1296 3296 1296
            BEGIN DISPLAY 3248 1296 ATTR "Name"
                ALIGNMENT SOFT-RIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "swFull"
            WIRE 3248 1376 3296 1376
            BEGIN DISPLAY 3248 1376 ATTR "Name"
                ALIGNMENT SOFT-RIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "XLXN_1720(68:0)"
            WIRE 2192 3968 2192 4896
        END BRANCH
        BEGIN INSTANCE "XLXI_233" 2992 5008 R0
        END INSTANCE
        BEGIN BRANCH "XLXN_1727"
            WIRE 3472 4832 3472 4896
        END BRANCH
        BEGIN BRANCH "store_buffer_req_bus"
            WIRE 3152 4832 3152 4864
            WIRE 3152 4864 3152 4896
            BEGIN DISPLAY 3152 4864 ATTR "Name"
                ALIGNMENT SOFT-TVCENTER
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "XLXN_1729(68:0)"
            WIRE 3312 4832 3312 4896
        END BRANCH
        BEGIN BRANCH "dispatch_swIssue"
            WIRE 2944 4272 2976 4272
            BEGIN DISPLAY 2944 4272 ATTR "Name"
                ALIGNMENT SOFT-RIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "dispatch_RSVk(15:0)"
            WIRE 2944 4336 2976 4336
            BEGIN DISPLAY 2944 4336 ATTR "Name"
                ALIGNMENT SOFT-RIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "dispatch_RSVj(31:0)"
            WIRE 2944 4400 2976 4400
            BEGIN DISPLAY 2944 4400 ATTR "Name"
                ALIGNMENT SOFT-RIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "dispatch_RSQj(4:0)"
            WIRE 2944 4464 2976 4464
            BEGIN DISPLAY 2944 4464 ATTR "Name"
                ALIGNMENT SOFT-RIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "dispatch_RSVstore(31:0)"
            WIRE 2944 4528 2976 4528
            BEGIN DISPLAY 2944 4528 ATTR "Name"
                ALIGNMENT SOFT-RIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "dispatch_RSQstore(4:0)"
            WIRE 2944 4592 2976 4592
            BEGIN DISPLAY 2944 4592 ATTR "Name"
                ALIGNMENT SOFT-RIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "dispatch_writeRegROBEntry(4:0)"
            WIRE 2944 4656 2976 4656
            BEGIN DISPLAY 2944 4656 ATTR "Name"
                ALIGNMENT SOFT-RIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "swFull"
            WIRE 3648 4272 3680 4272
            BEGIN DISPLAY 3680 4272 ATTR "Name"
                ALIGNMENT SOFT-LEFT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "store_buffer_addr_out(28:0)"
            WIRE 3648 4464 3680 4464
            BEGIN DISPLAY 3680 4464 ATTR "Name"
                ALIGNMENT SOFT-LEFT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "store_buffer_addr_out(28:0)"
            WIRE 5808 448 5808 496
            BEGIN DISPLAY 5808 448 ATTR "Name"
                ALIGNMENT SOFT-VLEFT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "store_buffer_req_bus"
            WIRE 5696 448 5696 496
            BEGIN DISPLAY 5696 448 ATTR "Name"
                ALIGNMENT SOFT-VLEFT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "load_buffer_addr_out(22:0)"
            WIRE 5440 1248 5520 1248
            BEGIN DISPLAY 5440 1248 ATTR "Name"
                ALIGNMENT SOFT-RIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "rob_loadData(31:0)"
            WIRE 6240 1248 6304 1248
            BEGIN DISPLAY 6304 1248 ATTR "Name"
                ALIGNMENT SOFT-LEFT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "rob_loadDataValid"
            WIRE 6240 1312 6304 1312
            BEGIN DISPLAY 6304 1312 ATTR "Name"
                ALIGNMENT SOFT-LEFT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "use_memio"
            WIRE 2528 3792 2576 3792
            BEGIN DISPLAY 2576 3792 ATTR "Name"
                ALIGNMENT SOFT-LEFT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "load_buffer_addr_out(22:0)"
            WIRE 2528 3728 2736 3728
            WIRE 2736 3392 2736 3728
            WIRE 2736 3392 2944 3392
        END BRANCH
        BEGIN BRANCH "data_req"
            WIRE 3472 2944 3472 2976
            BEGIN DISPLAY 3472 2944 ATTR "Name"
                ALIGNMENT SOFT-VLEFT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "XLXN_239(31:0)"
            WIRE 2928 2992 3360 2992
            WIRE 3360 2992 3360 3568
            WIRE 3312 3568 3360 3568
        END BRANCH
        BEGIN BRANCH "use_memio"
            WIRE 3504 3232 3504 3280
            BEGIN DISPLAY 3504 3280 ATTR "Name"
                ALIGNMENT SOFT-VRIGHT
            END DISPLAY
        END BRANCH
        INSTANCE "XLXI_232" 3568 3232 R270
        BEGIN BRANCH "XLXN_1710"
            WIRE 3312 3392 3440 3392
            WIRE 3440 3232 3440 3392
        END BRANCH
        BEGIN BRANCH "data_mem_addr(22:0)"
            WIRE 3312 3456 3392 3456
            BEGIN DISPLAY 3392 3456 ATTR "Name"
                ALIGNMENT SOFT-LEFT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "data_we_gate"
            WIRE 3120 2928 3120 2976
            BEGIN DISPLAY 3120 2928 ATTR "Name"
                ALIGNMENT SOFT-VLEFT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "burstReadDone"
            WIRE 3056 2928 3056 2976
            BEGIN DISPLAY 3056 2928 ATTR "Name"
                ALIGNMENT SOFT-VLEFT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "XLXN_1594"
            WIRE 3088 3232 3088 3264
        END BRANCH
        BEGIN BRANCH "cache_line(255:0)"
            WIRE 3168 3216 3168 3264
            BEGIN DISPLAY 3168 3216 ATTR "Name"
                ALIGNMENT SOFT-VLEFT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "commit_writeCache"
            WIRE 2848 3520 2944 3520
            WIRE 2848 3520 2848 3808
            BEGIN DISPLAY 2848 3808 ATTR "Name"
                ALIGNMENT SOFT-VRIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "rob_destOUT(22:0)"
            WIRE 2784 3456 2944 3456
            WIRE 2784 3456 2784 3808
            BEGIN DISPLAY 2784 3808 ATTR "Name"
                ALIGNMENT SOFT-VRIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "VCC"
            WIRE 3200 3712 3200 3760
            BEGIN DISPLAY 3200 3760 ATTR "Name"
                ALIGNMENT SOFT-VRIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "RST"
            WIRE 3072 3712 3072 3744
            BEGIN DISPLAY 3072 3744 ATTR "Name"
                ALIGNMENT SOFT-VRIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "CLK"
            WIRE 3136 3712 3136 3744
            BEGIN DISPLAY 3136 3744 ATTR "Name"
                ALIGNMENT SOFT-VRIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "rob_valueOUT(31:0)"
            WIRE 2912 3584 2944 3584
            WIRE 2912 3584 2912 3808
            BEGIN DISPLAY 2912 3808 ATTR "Name"
                ALIGNMENT SOFT-VRIGHT
            END DISPLAY
        END BRANCH
        BEGIN INSTANCE "data_cache" 2928 3696 R0
        END INSTANCE
        INSTANCE "XLXI_255" 2992 2976 R90
        INSTANCE "XLXI_254" 3104 2944 R180
        BEGIN BRANCH "mem_BiData(31:0)"
            WIRE 704 2528 832 2528
            WIRE 832 2528 944 2528
            BEGIN DISPLAY 832 2528 ATTR "Name"
                ALIGNMENT SOFT-BCENTER
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "RST"
            WIRE 896 2336 928 2336
            WIRE 928 2336 944 2336
            BEGIN DISPLAY 928 2336 ATTR "Name"
                ALIGNMENT SOFT-BCENTER
            END DISPLAY
        END BRANCH
        BEGIN INSTANCE "my_readBuffer" 944 2560 R0
        END INSTANCE
        BEGIN BRANCH "DRAMCLK"
            WIRE 896 2464 928 2464
            WIRE 928 2464 944 2464
            BEGIN DISPLAY 928 2464 ATTR "Name"
                ALIGNMENT SOFT-BCENTER
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "cache_line(255:0)"
            WIRE 1296 2400 1328 2400
            BEGIN DISPLAY 1328 2400 ATTR "Name"
                ALIGNMENT SOFT-LEFT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "data_mem_addr(22:0)"
            WIRE 224 3248 256 3248
            BEGIN DISPLAY 224 3248 ATTR "Name"
                ALIGNMENT SOFT-RIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "inst_mem_addr(22:0)"
            WIRE 224 3184 256 3184
            BEGIN DISPLAY 224 3184 ATTR "Name"
                ALIGNMENT SOFT-RIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "RST"
            WIRE 224 3120 256 3120
            BEGIN DISPLAY 224 3120 ATTR "Name"
                ALIGNMENT SOFT-RIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "CLK"
            WIRE 224 3056 256 3056
            BEGIN DISPLAY 224 3056 ATTR "Name"
                ALIGNMENT SOFT-RIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "waitForMem"
            WIRE 224 2992 256 2992
            BEGIN DISPLAY 224 2992 ATTR "Name"
                ALIGNMENT SOFT-RIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "robFull"
            WIRE 224 2928 256 2928
            BEGIN DISPLAY 224 2928 ATTR "Name"
                ALIGNMENT SOFT-RIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "GND"
            WIRE 32 2864 256 2864
            BEGIN DISPLAY 32 2864 ATTR "Name"
                ALIGNMENT SOFT-RIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "data_req"
            WIRE 224 2800 256 2800
            BEGIN DISPLAY 224 2800 ATTR "Name"
                ALIGNMENT SOFT-RIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "inst_req"
            WIRE 224 2736 256 2736
            BEGIN DISPLAY 224 2736 ATTR "Name"
                ALIGNMENT SOFT-RIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "mem_request"
            WIRE 880 2736 912 2736
            BEGIN DISPLAY 912 2736 ATTR "Name"
                ALIGNMENT SOFT-LEFT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "mem_r_w"
            WIRE 880 2800 912 2800
            BEGIN DISPLAY 912 2800 ATTR "Name"
                ALIGNMENT SOFT-LEFT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "arbiter_WB_granted"
            WIRE 880 2864 912 2864
            BEGIN DISPLAY 912 2864 ATTR "Name"
                ALIGNMENT SOFT-LEFT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "mem_addr(22:0)"
            WIRE 880 2976 912 2976
            BEGIN DISPLAY 912 2976 ATTR "Name"
                ALIGNMENT SOFT-LEFT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "mem_data(31:0)"
            WIRE 880 3040 912 3040
            BEGIN DISPLAY 912 3040 ATTR "Name"
                ALIGNMENT SOFT-LEFT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "data_we_gate"
            WIRE 880 3216 912 3216
            BEGIN DISPLAY 912 3216 ATTR "Name"
                ALIGNMENT SOFT-LEFT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "inst_we_gate"
            WIRE 880 3152 912 3152
            BEGIN DISPLAY 912 3152 ATTR "Name"
                ALIGNMENT SOFT-LEFT
            END DISPLAY
        END BRANCH
        BEGIN INSTANCE "my_arbiter" 256 3408 R0
        END INSTANCE
        BEGIN BRANCH "rob_destOUT(22:0)"
            WIRE 224 3312 256 3312
            BEGIN DISPLAY 224 3312 ATTR "Name"
                ALIGNMENT SOFT-RIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "rob_valueOUT(31:0)"
            WIRE 224 3376 256 3376
            BEGIN DISPLAY 224 3376 ATTR "Name"
                ALIGNMENT SOFT-RIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "CLK"
            WIRE 2208 3248 2208 3328
            BEGIN DISPLAY 2208 3248 ATTR "Name"
                ALIGNMENT SOFT-VLEFT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "RST"
            WIRE 2304 3248 2304 3328
            BEGIN DISPLAY 2304 3248 ATTR "Name"
                ALIGNMENT SOFT-VLEFT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "cdb_dout(36:0)"
            WIRE 2080 3248 2080 3328
            BEGIN DISPLAY 2080 3248 ATTR "Name"
                ALIGNMENT SOFT-VLEFT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "cdb_dout_en"
            WIRE 1984 3248 1984 3328
            BEGIN DISPLAY 1984 3248 ATTR "Name"
                ALIGNMENT SOFT-VLEFT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "rollback"
            WIRE 2400 3248 2400 3328
            BEGIN DISPLAY 2400 3248 ATTR "Name"
                ALIGNMENT SOFT-VLEFT
            END DISPLAY
        END BRANCH
        BEGIN INSTANCE "my_load_buffer" 1872 4224 R0
        END INSTANCE
        BEGIN BRANCH "dispatch_lwIssue"
            WIRE 1824 3504 1856 3504
            BEGIN DISPLAY 1824 3504 ATTR "Name"
                ALIGNMENT SOFT-RIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "dispatch_RSVk(15:0)"
            WIRE 1824 3568 1856 3568
            BEGIN DISPLAY 1824 3568 ATTR "Name"
                ALIGNMENT SOFT-RIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "dispatch_RSVj(31:0)"
            WIRE 1824 3632 1856 3632
            BEGIN DISPLAY 1824 3632 ATTR "Name"
                ALIGNMENT SOFT-RIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "dispatch_RSQj(4:0)"
            WIRE 1824 3696 1856 3696
            BEGIN DISPLAY 1824 3696 ATTR "Name"
                ALIGNMENT SOFT-RIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "lwFull"
            WIRE 2528 3488 2576 3488
            WIRE 2576 3456 2576 3488
            BEGIN DISPLAY 2576 3456 ATTR "Name"
                ALIGNMENT SOFT-VLEFT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "dispatch_writeRegROBEntry(4:0)"
            WIRE 1824 3760 1856 3760
            BEGIN DISPLAY 1824 3760 ATTR "Name"
                ALIGNMENT SOFT-RIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "memio_dout(31:0)"
            WIRE 1776 3072 1872 3072
            WIRE 1872 2816 1872 3072
            WIRE 1872 2816 2064 2816
            WIRE 2064 2816 2992 2816
            WIRE 2992 2816 2992 2928
            WIRE 2928 2928 2992 2928
            BEGIN DISPLAY 2064 2816 ATTR "Name"
                ALIGNMENT SOFT-BCENTER
            END DISPLAY
        END BRANCH
        INSTANCE "XLXI_270" 2640 2992 R90
        BEGIN BRANCH "rob_loadDataValid"
            WIRE 2816 3280 2848 3280
            BEGIN DISPLAY 2848 3280 ATTR "Name"
                ALIGNMENT SOFT-LEFT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "rob_loadData(31:0)"
            WIRE 2624 3072 2624 3168
            BEGIN DISPLAY 2624 3072 ATTR "Name"
                ALIGNMENT SOFT-VLEFT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "XLXN_1925(31:0)"
            WIRE 2528 3632 2656 3632
            WIRE 2656 3392 2656 3632
        END BRANCH
        BEGIN BRANCH "XLXN_1926(31:0)"
            WIRE 2688 2960 2704 2960
            WIRE 2688 2960 2688 3168
        END BRANCH
        BEGIN BRANCH "use_memio"
            WIRE 2816 3120 2816 3152
            WIRE 2816 3152 2816 3168
            BEGIN DISPLAY 2816 3152 ATTR "Name"
                ALIGNMENT SOFT-TVCENTER
            END DISPLAY
        END BRANCH
        BEGIN INSTANCE "my_memio" 1248 3344 R0
        END INSTANCE
        BEGIN BRANCH "CLK"
            WIRE 1600 3344 1600 3392
            BEGIN DISPLAY 1600 3392 ATTR "Name"
                ALIGNMENT SOFT-VRIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "VCC"
            WIRE 1520 2960 1520 2992
            BEGIN DISPLAY 1520 2960 ATTR "Name"
                ALIGNMENT SOFT-VLEFT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "RST"
            WIRE 1584 2960 1584 2992
            BEGIN DISPLAY 1584 2960 ATTR "Name"
                ALIGNMENT SOFT-VLEFT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "memio_out(31:0)"
            WIRE 1776 3200 1808 3200
            WIRE 1808 3200 1824 3200
            BEGIN DISPLAY 1808 3200 ATTR "Name"
                ALIGNMENT SOFT-BCENTER
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "use_memio"
            WIRE 1360 3056 1392 3056
            BEGIN DISPLAY 1360 3056 ATTR "Name"
                ALIGNMENT SOFT-RIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "rob_destOUT(22:0)"
            WIRE 1360 3152 1392 3152
            BEGIN DISPLAY 1360 3152 ATTR "Name"
                ALIGNMENT SOFT-RIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "rob_valueOUT(31:0)"
            WIRE 1360 3216 1392 3216
            BEGIN DISPLAY 1360 3216 ATTR "Name"
                ALIGNMENT SOFT-RIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "rob_destOUT(22:0)"
            WIRE 1360 3312 1392 3312
            BEGIN DISPLAY 1360 3312 ATTR "Name"
                ALIGNMENT SOFT-RIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "memio_outsel"
            WIRE 1648 2960 1648 2992
            BEGIN DISPLAY 1648 2960 ATTR "Name"
                ALIGNMENT SOFT-VLEFT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "memio_in(7:0)"
            WIRE 1360 3264 1392 3264
            BEGIN DISPLAY 1360 3264 ATTR "Name"
                ALIGNMENT SOFT-RIGHT
            END DISPLAY
        END BRANCH
        BEGIN DISPLAY 1360 3312 TEXT ?
            FONT 52 "Arial"
        END DISPLAY
        BEGIN BRANCH "waitForMem"
            WIRE 704 1760 736 1760
            BEGIN DISPLAY 736 1760 ATTR "Name"
                ALIGNMENT SOFT-LEFT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "data_req"
            WIRE 2528 3568 2560 3568
            WIRE 2560 3568 2576 3568
            BEGIN DISPLAY 2560 3568 ATTR "Name"
                ALIGNMENT SOFT-BCENTER
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "XLXN_1928"
            WIRE 1840 1440 1936 1440
            WIRE 1936 1344 1936 1440
        END BRANCH
        INSTANCE "XLXI_273" 2192 992 R270
        BEGIN BRANCH "XLXN_1931"
            WIRE 2048 1024 2064 1024
            WIRE 2064 992 2064 1024
        END BRANCH
        BEGIN BRANCH "inst_req"
            WIRE 2096 704 2096 736
            BEGIN DISPLAY 2096 704 ATTR "Name"
                ALIGNMENT SOFT-VLEFT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "inst_mem_addr(22:0)"
            WIRE 2048 1088 2080 1088
            WIRE 2080 1088 2096 1088
            BEGIN DISPLAY 2080 1088 ATTR "Name"
                ALIGNMENT SOFT-BCENTER
            END DISPLAY
        END BRANCH
        BEGIN INSTANCE "my_HI_LO" 6272 2976 R0
        END INSTANCE
        BEGIN BRANCH "reg_HI_LO(31:0)"
            WIRE 6608 2816 6624 2816
            WIRE 6624 2816 6640 2816
            WIRE 6640 1968 6640 2688
            WIRE 6640 2688 6640 2816
            BEGIN DISPLAY 6640 2688 ATTR "Name"
                ALIGNMENT SOFT-TVCENTER
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "rob_readPredAddr(31:0)"
            WIRE 6240 704 6304 704
            BEGIN DISPLAY 6304 704 ATTR "Name"
                ALIGNMENT SOFT-LEFT
            END DISPLAY
        END BRANCH
        BEGIN INSTANCE "my_commit" 4736 2224 R0
        END INSTANCE
        BEGIN BRANCH "stat_output(7:0)"
            WIRE 5344 2128 5408 2128
            BEGIN DISPLAY 5408 2128 ATTR "Name"
                ALIGNMENT SOFT-LEFT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "regStatCommit"
            WIRE 5344 1936 5408 1936
            BEGIN DISPLAY 5408 1936 ATTR "Name"
                ALIGNMENT SOFT-LEFT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "regFileCommit"
            WIRE 5344 1872 5408 1872
            BEGIN DISPLAY 5408 1872 ATTR "Name"
                ALIGNMENT SOFT-LEFT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "commit_robCommit"
            WIRE 5344 2064 5408 2064
            BEGIN DISPLAY 5408 2064 ATTR "Name"
                ALIGNMENT SOFT-LEFT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "rls"
            WIRE 4672 1872 4736 1872
            BEGIN DISPLAY 4672 1872 ATTR "Name"
                ALIGNMENT SOFT-RIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "robReady"
            WIRE 4672 1936 4688 1936
            WIRE 4688 1936 4736 1936
            BEGIN DISPLAY 4672 1936 ATTR "Name"
                ALIGNMENT SOFT-RIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "rob_valueOUT(31:0)"
            WIRE 4672 2192 4688 2192
            WIRE 4688 2192 4736 2192
            BEGIN DISPLAY 4672 2192 ATTR "Name"
                ALIGNMENT SOFT-RIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "rob_destOUT(4:0)"
            WIRE 4672 2064 4688 2064
            WIRE 4688 2064 4736 2064
            BEGIN DISPLAY 4672 2064 ATTR "Name"
                ALIGNMENT SOFT-RIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "rob_commitPtr(4:0)"
            WIRE 4672 2000 4688 2000
            WIRE 4688 2000 4736 2000
            BEGIN DISPLAY 4672 2000 ATTR "Name"
                ALIGNMENT SOFT-RIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "dm_instr(31:0)"
            WIRE 4688 2128 4704 2128
            WIRE 4704 2128 4736 2128
            BEGIN DISPLAY 4688 2128 ATTR "Name"
                ALIGNMENT SOFT-RIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "dReorder(4:0)"
            WIRE 4688 2256 4704 2256
            WIRE 4704 2256 4736 2256
            BEGIN DISPLAY 4688 2256 ATTR "Name"
                ALIGNMENT SOFT-RIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "rob_readPredAddr(31:0)"
            WIRE 4688 2320 4736 2320
            BEGIN DISPLAY 4688 2320 ATTR "Name"
                ALIGNMENT SOFT-RIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "commit_regFileOut(31:0)"
            WIRE 5344 2000 5408 2000
            BEGIN DISPLAY 5408 2000 ATTR "Name"
                ALIGNMENT SOFT-LEFT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "commit_writeRegBusy"
            WIRE 5344 2192 5408 2192
            BEGIN DISPLAY 5408 2192 ATTR "Name"
                ALIGNMENT SOFT-LEFT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "commit_writeReg(4:0)"
            WIRE 5344 2256 5408 2256
            BEGIN DISPLAY 5408 2256 ATTR "Name"
                ALIGNMENT SOFT-LEFT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "commit_rollBack"
            WIRE 5344 2320 5408 2320
            BEGIN DISPLAY 5408 2320 ATTR "Name"
                ALIGNMENT SOFT-LEFT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "dispatch_robIssue"
            WIRE 3056 208 3136 208
            BEGIN DISPLAY 3056 208 ATTR "Name"
                ALIGNMENT SOFT-RIGHT
            END DISPLAY
        END BRANCH
        BEGIN INSTANCE "ID_branchUnit" 2352 2048 R0
        END INSTANCE
        BEGIN BRANCH "addr_notTaken(31:0)"
            WIRE 1824 2560 1856 2560
            WIRE 1856 2560 2032 2560
            BEGIN DISPLAY 1856 2560 ATTR "Name"
                ALIGNMENT SOFT-BCENTER
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "addr_taken(31:0)"
            WIRE 1824 2608 1840 2608
            WIRE 1840 2608 2032 2608
            BEGIN DISPLAY 1840 2608 ATTR "Name"
                ALIGNMENT SOFT-BCENTER
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "dispatch_jrStall"
            WIRE 3984 2320 4048 2320
            BEGIN DISPLAY 4048 2320 ATTR "Name"
                ALIGNMENT SOFT-LEFT
            END DISPLAY
        END BRANCH
        INSTANCE "XLXI_274" 2336 800 R90
        BEGIN BRANCH "dispatch_jrStall"
            WIRE 2368 784 2368 800
            WIRE 2368 784 2416 784
            BEGIN DISPLAY 2416 784 ATTR "Name"
                ALIGNMENT SOFT-LEFT
            END DISPLAY
        END BRANCH
        INSTANCE "XLXI_275" 1584 1568 R0
        BEGIN BRANCH "dispatch_RSBusy"
            WIRE 1536 1376 1552 1376
            WIRE 1552 1376 1584 1376
            BEGIN DISPLAY 1552 1376 ATTR "Name"
                ALIGNMENT SOFT-BCENTER
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "branchUnit_stall"
            WIRE 1536 1440 1552 1440
            WIRE 1552 1440 1584 1440
            BEGIN DISPLAY 1552 1440 ATTR "Name"
                ALIGNMENT SOFT-BCENTER
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "dispatch_jrStall"
            WIRE 1536 1504 1584 1504
            BEGIN DISPLAY 1536 1504 ATTR "Name"
                ALIGNMENT SOFT-RIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "XLXN_1937"
            WIRE 960 448 960 464
        END BRANCH
        INSTANCE "XLXI_276" 928 224 R90
        BEGIN BRANCH "dispatch_jrStall"
            WIRE 960 208 960 224
            BEGIN DISPLAY 960 208 ATTR "Name"
                ALIGNMENT SOFT-VLEFT
            END DISPLAY
        END BRANCH
        BEGIN INSTANCE "my_pcSelect" 1616 2144 R0
        END INSTANCE
        BEGIN INSTANCE "XLXI_278" 1584 1632 R0
        END INSTANCE
    END SHEET
END SCHEMATIC
