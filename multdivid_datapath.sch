VERSION 6
BEGIN SCHEMATIC
    BEGIN ATTR DeviceFamilyName "virtexe"
        DELETE all:0
        EDITNAME all:0
        EDITTRAIT all:0
    END ATTR
    BEGIN NETLIST
        SIGNAL "WE_multiplicand_divider"
        SIGNAL "WE_multiplier_dividend"
        SIGNAL "neg"
        SIGNAL "Result_reg_WE"
        SIGNAL "busy"
        SIGNAL "shift"
        SIGNAL "op"
        SIGNAL "signed_op"
        SIGNAL "WE_sub"
        SIGNAL "adder_ctr_sel"
        SIGNAL "multiplicand_divider(33:0)"
        SIGNAL "multiplier_dividen(33:0)"
        SIGNAL "shift_type(1:0)"
        SIGNAL "multiplicand_divider_in(31:0)"
        SIGNAL "multiplier_dividen_in(31:0)"
        SIGNAL "op_in"
        SIGNAL "signedOp_in"
        SIGNAL "XLXN_25(67:0)"
        SIGNAL "XLXN_26(33:0)"
        SIGNAL "resultofAdd(33:0)"
        SIGNAL "clk"
        SIGNAL "XLXN_41(33:0)"
        SIGNAL "XLXN_43(33:0)"
        SIGNAL "XLXN_45(33:0)"
        SIGNAL "adder_src_sel(1:0)"
        SIGNAL "XLXN_51(33:0)"
        SIGNAL "hi_out(31:0)"
        SIGNAL "lo_out(31:0)"
        SIGNAL "rst"
        SIGNAL "resultofAdd(33)"
        PORT Output "busy"
        PORT Input "multiplicand_divider_in(31:0)"
        PORT Input "multiplier_dividen_in(31:0)"
        PORT Input "op_in"
        PORT Input "signedOp_in"
        PORT Input "clk"
        PORT Output "hi_out(31:0)"
        PORT Output "lo_out(31:0)"
        PORT Input "rst"
        BEGIN BLOCKDEF "multdivid_controller"
            TIMESTAMP 2003 11 15 14 50 42
            RECTANGLE N 64 -896 976 0 
            LINE N 64 -864 0 -864 
            LINE N 60 -720 -4 -720 
            LINE N 60 -192 -4 -192 
            LINE N 64 -448 0 -448 
            LINE N 64 -592 0 -592 
            LINE N 976 -864 1040 -864 
            LINE N 976 -800 1040 -800 
            LINE N 976 -736 1040 -736 
            LINE N 976 -672 1040 -672 
            LINE N 976 -608 1040 -608 
            LINE N 976 -544 1040 -544 
            LINE N 976 -480 1040 -480 
            LINE N 976 -416 1040 -416 
            LINE N 976 -352 1040 -352 
            LINE N 976 -288 1040 -288 
            LINE N 976 -224 1040 -224 
            RECTANGLE N 976 -236 1040 -212 
            LINE N 976 -160 1040 -160 
            RECTANGLE N 976 -172 1040 -148 
            LINE N 976 -96 1040 -96 
            RECTANGLE N 976 -108 1040 -84 
            LINE N 976 -32 1040 -32 
            RECTANGLE N 976 -44 1040 -20 
            LINE N 544 0 592 -84 
            LINE N 592 -84 644 0 
            RECTANGLE N 0 -604 64 -580 
            RECTANGLE N 0 -460 64 -436 
        END BLOCKDEF
        BEGIN BLOCKDEF "multdivid_divisor_multiplier"
            TIMESTAMP 2003 11 13 14 44 21
            RECTANGLE N 64 -192 528 0 
            LINE N 64 -160 0 -160 
            LINE N 64 -96 0 -96 
            LINE N 64 -32 0 -32 
            RECTANGLE N 0 -44 64 -20 
            LINE N 528 -160 592 -160 
            RECTANGLE N 528 -172 592 -148 
        END BLOCKDEF
        BEGIN BLOCKDEF "multdivid_divisor_multiplier_postwo"
            TIMESTAMP 2003 11 14 9 20 51
            RECTANGLE N 64 -64 400 0 
            LINE N 64 -32 0 -32 
            RECTANGLE N 0 -44 64 -20 
            LINE N 400 -32 464 -32 
            RECTANGLE N 400 -44 464 -20 
        END BLOCKDEF
        BEGIN BLOCKDEF "zeroes"
            TIMESTAMP 2003 11 17 23 44 18
            RECTANGLE N 64 -64 320 0 
            LINE N 320 -32 384 -32 
            RECTANGLE N 320 -44 384 -20 
        END BLOCKDEF
        BEGIN BLOCKDEF "multdivid_result"
            TIMESTAMP 2003 11 15 14 50 44
            LINE N 832 -560 896 -560 
            RECTANGLE N 832 -572 896 -548 
            LINE N 836 -512 900 -512 
            RECTANGLE N 832 -520 896 -496 
            RECTANGLE N 48 -716 832 -420 
            LINE N 360 -420 428 -472 
            LINE N 428 -472 484 -420 
            LINE N 424 -716 424 -684 
            LINE N 424 -664 424 -636 
            LINE N 424 -616 424 -588 
            LINE N 424 -560 424 -528 
            LINE N 428 -500 428 -472 
        END BLOCKDEF
        BEGIN BLOCKDEF "multdivid_adder"
            TIMESTAMP 2003 11 14 0 3 55
            LINE N 0 96 44 96 
            LINE N 64 -140 64 -140 
            LINE N 160 0 0 0 
            LINE N 160 0 256 0 
            LINE N 256 0 324 32 
            LINE N 324 32 384 0 
            LINE N 384 0 640 0 
            LINE N 0 0 80 160 
            LINE N 80 160 560 160 
            LINE N 560 160 640 0 
            LINE N 512 0 512 -44 
            LINE N 128 0 128 -48 
        END BLOCKDEF
        BEGIN BLOCKDEF "m34x3"
            TIMESTAMP 2003 11 17 23 44 17
            LINE N 272 -80 208 -80 
            LINE N 320 0 396 0 
            LINE N 404 0 544 -208 
            LINE N 544 -208 192 -208 
            LINE N 320 0 192 -208 
            RECTANGLE N 208 -92 272 -68 
        END BLOCKDEF
        BEGIN BLOCKDEF "multdivid_splitter"
            TIMESTAMP 2003 11 14 9 20 51
            LINE N 64 32 0 32 
            LINE N 64 96 0 96 
            LINE N 64 -96 0 -96 
            RECTANGLE N 0 -108 64 -84 
            LINE N 368 -96 432 -96 
            RECTANGLE N 368 -108 432 -84 
            LINE N 368 -32 432 -32 
            RECTANGLE N 368 -44 432 -20 
            RECTANGLE N 64 -128 368 128 
        END BLOCKDEF
        BEGIN BLOCK "XLXI_1" "multdivid_controller"
            PIN "signedOp" "signedOp_in"
            PIN "op" "op_in"
            PIN "clk" "clk"
            PIN "rst" "rst"
            PIN "answerMSB" "resultofAdd(33)"
            PIN "multiplicand_divider(31:0)" "multiplicand_divider_in(31:0)"
            PIN "multiplier_dividen(31:0)" "multiplier_dividen_in(31:0)"
            PIN "WE_multiplicand_divider" "WE_multiplicand_divider"
            PIN "WE_multiplier_dividen" "WE_multiplier_dividend"
            PIN "neg" "neg"
            PIN "productWrite" "Result_reg_WE"
            PIN "busy" "busy"
            PIN "shift" "shift"
            PIN "op_out" "op"
            PIN "signed_out" "signed_op"
            PIN "WE_sub" "WE_sub"
            PIN "adder_ctr" "adder_ctr_sel"
            PIN "multiplicand_divider_out(33:0)" "multiplicand_divider(33:0)"
            PIN "multiplier_dividen_out(33:0)" "multiplier_dividen(33:0)"
            PIN "shift_type(1:0)" "shift_type(1:0)"
            PIN "adder_src(1:0)" "adder_src_sel(1:0)"
        END BLOCK
        BEGIN BLOCK "XLXI_2" "multdivid_divisor_multiplier"
            PIN "clk" "clk"
            PIN "WE" "WE_multiplicand_divider"
            PIN "value(33:0)" "multiplicand_divider(33:0)"
            PIN "value_out(33:0)" "XLXN_41(33:0)"
        END BLOCK
        BEGIN BLOCK "XLXI_3" "multdivid_divisor_multiplier_postwo"
            PIN "in0(33:0)" "XLXN_41(33:0)"
            PIN "out0(33:0)" "XLXN_43(33:0)"
        END BLOCK
        BEGIN BLOCK "XLXI_4" "zeroes"
            PIN "zeroesO(33:0)" "XLXN_45(33:0)"
        END BLOCK
        BEGIN BLOCK "XLXI_5" "multdivid_result"
            PIN "signedOp" "signed_op"
            PIN "op" "op"
            PIN "init_we" "WE_multiplier_dividend"
            PIN "clk" "clk"
            PIN "WE" "Result_reg_WE"
            PIN "WE_sub" "WE_sub"
            PIN "shift" "shift"
            PIN "multiplierDividen(33:0)" "multiplier_dividen(33:0)"
            PIN "resultOfAdd(33:0)" "resultofAdd(33:0)"
            PIN "shift_type(1:0)" "shift_type(1:0)"
            PIN "productOut(33:0)" "XLXN_26(33:0)"
            PIN "answer(67:0)" "XLXN_25(67:0)"
        END BLOCK
        BEGIN BLOCK "XLXI_6" "multdivid_adder"
            PIN "op" "adder_ctr_sel"
            PIN "in0(33:0)" "XLXN_26(33:0)"
            PIN "in1(33:0)" "XLXN_51(33:0)"
            PIN "sum(33:0)" "resultofAdd(33:0)"
        END BLOCK
        BEGIN BLOCK "XLXI_7" "m34x3"
            PIN "in0(33:0)" "XLXN_45(33:0)"
            PIN "in1(33:0)" "XLXN_41(33:0)"
            PIN "in2(33:0)" "XLXN_43(33:0)"
            PIN "sel(1:0)" "adder_src_sel(1:0)"
            PIN "out0(33:0)" "XLXN_51(33:0)"
        END BLOCK
        BEGIN BLOCK "XLXI_8" "multdivid_splitter"
            PIN "in0(67:0)" "XLXN_25(67:0)"
            PIN "hi(31:0)" "hi_out(31:0)"
            PIN "lo(31:0)" "lo_out(31:0)"
            PIN "op" "op"
            PIN "neg" "neg"
        END BLOCK
    END NETLIST
    BEGIN SHEET 1 5440 3520
        BEGIN INSTANCE "XLXI_1" 576 3056 R0
        END INSTANCE
        BEGIN INSTANCE "XLXI_2" 1168 1568 R0
        END INSTANCE
        BEGIN INSTANCE "XLXI_6" 2736 2288 R0
        END INSTANCE
        BEGIN INSTANCE "XLXI_7" 2880 2112 R0
        END INSTANCE
        BEGIN INSTANCE "XLXI_5" 2560 3456 R0
        END INSTANCE
        BEGIN INSTANCE "XLXI_8" 4032 2880 R0
        END INSTANCE
        BEGIN BRANCH "WE_multiplicand_divider"
            WIRE 1616 2192 1664 2192
            BEGIN DISPLAY 1664 2192 ATTR "Name"
                ALIGNMENT SOFT-LEFT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "WE_multiplier_dividend"
            WIRE 1616 2256 1664 2256
            BEGIN DISPLAY 1664 2256 ATTR "Name"
                ALIGNMENT SOFT-LEFT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "neg"
            WIRE 1616 2320 1664 2320
            BEGIN DISPLAY 1664 2320 ATTR "Name"
                ALIGNMENT SOFT-LEFT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "Result_reg_WE"
            WIRE 1616 2384 1664 2384
            BEGIN DISPLAY 1664 2384 ATTR "Name"
                ALIGNMENT SOFT-LEFT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "busy"
            WIRE 1616 2448 1664 2448
        END BRANCH
        BEGIN BRANCH "shift"
            WIRE 1616 2512 1664 2512
            BEGIN DISPLAY 1664 2512 ATTR "Name"
                ALIGNMENT SOFT-LEFT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "op"
            WIRE 1616 2576 1664 2576
            BEGIN DISPLAY 1664 2576 ATTR "Name"
                ALIGNMENT SOFT-LEFT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "signed_op"
            WIRE 1616 2640 1664 2640
            BEGIN DISPLAY 1664 2640 ATTR "Name"
                ALIGNMENT SOFT-LEFT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "WE_sub"
            WIRE 1616 2704 1664 2704
            BEGIN DISPLAY 1664 2704 ATTR "Name"
                ALIGNMENT SOFT-LEFT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "adder_ctr_sel"
            WIRE 1616 2768 1664 2768
            BEGIN DISPLAY 1664 2768 ATTR "Name"
                ALIGNMENT SOFT-LEFT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "multiplicand_divider(33:0)"
            WIRE 1616 2832 1664 2832
            BEGIN DISPLAY 1664 2832 ATTR "Name"
                ALIGNMENT SOFT-LEFT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "multiplier_dividen(33:0)"
            WIRE 1616 2896 1664 2896
            BEGIN DISPLAY 1664 2896 ATTR "Name"
                ALIGNMENT SOFT-LEFT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "shift_type(1:0)"
            WIRE 1616 2960 1664 2960
            BEGIN DISPLAY 1664 2960 ATTR "Name"
                ALIGNMENT SOFT-LEFT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "resultofAdd(33)"
            WIRE 400 2864 416 2864
            WIRE 416 2864 528 2864
            WIRE 528 2864 544 2864
            WIRE 544 2864 576 2864
            BEGIN DISPLAY 416 2864 ATTR "Name"
                ALIGNMENT SOFT-BCENTER
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "multiplicand_divider_in(31:0)"
            WIRE 512 2608 576 2608
        END BRANCH
        BEGIN BRANCH "multiplier_dividen_in(31:0)"
            WIRE 512 2464 576 2464
        END BRANCH
        BEGIN BRANCH "op_in"
            WIRE 512 2336 576 2336
        END BRANCH
        BEGIN BRANCH "signedOp_in"
            WIRE 512 2192 576 2192
        END BRANCH
        BEGIN BRANCH "XLXN_25(67:0)"
            WIRE 3456 2944 3920 2944
            WIRE 3920 2784 3920 2944
            WIRE 3920 2784 4016 2784
            WIRE 4016 2784 4032 2784
        END BRANCH
        BEGIN BRANCH "multiplier_dividen(33:0)"
            WIRE 2544 2880 2560 2880
            WIRE 2560 2880 2608 2880
            BEGIN DISPLAY 2544 2880 ATTR "Name"
                ALIGNMENT SOFT-RIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "resultofAdd(33:0)"
            WIRE 112 2864 112 3440
            WIRE 112 3440 1248 3440
            WIRE 1248 3440 1248 3456
            WIRE 1248 3456 2096 3456
            WIRE 112 2864 304 2864
            WIRE 2096 3280 2096 3456
            WIRE 2096 3280 2224 3280
            WIRE 2176 2512 2176 2944
            WIRE 2176 2944 2224 2944
            WIRE 2224 2944 2592 2944
            WIRE 2592 2944 2608 2944
            WIRE 2224 2944 2224 3280
            WIRE 2176 2512 2256 2512
            WIRE 2256 2512 3056 2512
            WIRE 3056 2448 3056 2464
            WIRE 3056 2464 3056 2512
            BEGIN DISPLAY 2256 2512 ATTR "Name"
                ALIGNMENT SOFT-BCENTER
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "signed_op"
            WIRE 2640 2688 2640 2704
            WIRE 2640 2704 2640 2736
            BEGIN DISPLAY 2640 2688 ATTR "Name"
                ALIGNMENT SOFT-VLEFT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "op"
            WIRE 2768 2688 2768 2704
            WIRE 2768 2704 2768 2736
            BEGIN DISPLAY 2768 2688 ATTR "Name"
                ALIGNMENT SOFT-VLEFT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "WE_multiplier_dividend"
            WIRE 2848 2688 2848 2704
            WIRE 2848 2704 2848 2736
            BEGIN DISPLAY 2848 2688 ATTR "Name"
                ALIGNMENT SOFT-VLEFT
                FONT 18 "Arial"
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "Result_reg_WE"
            WIRE 2928 2688 2928 2704
            WIRE 2928 2704 2928 2736
            BEGIN DISPLAY 2928 2688 ATTR "Name"
                ALIGNMENT SOFT-VLEFT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "WE_sub"
            WIRE 3120 2688 3120 2704
            WIRE 3120 2704 3120 2736
            BEGIN DISPLAY 3120 2688 ATTR "Name"
                ALIGNMENT SOFT-VLEFT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "shift"
            WIRE 3200 2688 3200 2704
            WIRE 3200 2704 3200 2736
            BEGIN DISPLAY 3200 2688 ATTR "Name"
                ALIGNMENT SOFT-VLEFT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "shift_type(1:0)"
            WIRE 3312 2688 3312 2704
            WIRE 3312 2704 3312 2736
            BEGIN DISPLAY 3312 2688 ATTR "Name"
                ALIGNMENT SOFT-VLEFT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "clk"
            WIRE 1136 1408 1168 1408
            BEGIN DISPLAY 1136 1408 ATTR "Name"
                ALIGNMENT SOFT-RIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "WE_multiplicand_divider"
            WIRE 1136 1472 1168 1472
            BEGIN DISPLAY 1136 1472 ATTR "Name"
                ALIGNMENT SOFT-RIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "multiplicand_divider(33:0)"
            WIRE 1136 1536 1168 1536
            BEGIN DISPLAY 1136 1536 ATTR "Name"
                ALIGNMENT SOFT-RIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "XLXN_43(33:0)"
            WIRE 3360 1648 3360 1904
        END BRANCH
        BEGIN INSTANCE "XLXI_3" 3328 1184 R90
        END INSTANCE
        BEGIN BRANCH "XLXN_41(33:0)"
            WIRE 1760 1408 2880 1408
            WIRE 2880 1120 2880 1408
            WIRE 2880 1120 3248 1120
            WIRE 3248 1120 3360 1120
            WIRE 3360 1120 3360 1184
            WIRE 3248 1120 3248 1904
        END BRANCH
        BEGIN INSTANCE "XLXI_4" 3088 1280 R90
        END INSTANCE
        BEGIN BRANCH "XLXN_45(33:0)"
            WIRE 3120 1664 3120 1904
        END BRANCH
        BEGIN BRANCH "adder_ctr_sel"
            WIRE 2704 2384 2720 2384
            WIRE 2720 2384 2736 2384
            BEGIN DISPLAY 2704 2384 ATTR "Name"
                ALIGNMENT SOFT-RIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "adder_src_sel(1:0)"
            WIRE 1616 3024 1664 3024
            BEGIN DISPLAY 1664 3024 ATTR "Name"
                ALIGNMENT SOFT-LEFT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "adder_src_sel(1:0)"
            WIRE 3008 2032 3088 2032
            BEGIN DISPLAY 3008 2032 ATTR "Name"
                ALIGNMENT SOFT-RIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "XLXN_26(33:0)"
            WIRE 2064 2192 2064 3216
            WIRE 2064 3216 3840 3216
            WIRE 2064 2192 2864 2192
            WIRE 2864 2192 2864 2240
            WIRE 2864 2240 2864 2256
            WIRE 3456 2896 3840 2896
            WIRE 3840 2896 3840 3216
        END BRANCH
        BEGIN BRANCH "XLXN_51(33:0)"
            WIRE 3248 2112 3248 2240
            WIRE 3248 2240 3248 2256
        END BRANCH
        BEGIN BRANCH "op"
            WIRE 4000 2912 4032 2912
            BEGIN DISPLAY 4000 2912 ATTR "Name"
                ALIGNMENT SOFT-RIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "neg"
            WIRE 4000 2976 4032 2976
            BEGIN DISPLAY 4000 2976 ATTR "Name"
                ALIGNMENT SOFT-RIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "hi_out(31:0)"
            WIRE 4464 2784 4528 2784
        END BRANCH
        BEGIN BRANCH "lo_out(31:0)"
            WIRE 4464 2848 4528 2848
        END BRANCH
        BEGIN BRANCH "clk"
            WIRE 640 3312 1168 3312
            WIRE 1168 3056 1168 3312
            BEGIN DISPLAY 640 3312 ATTR "Name"
                ALIGNMENT SOFT-RIGHT
            END DISPLAY
        END BRANCH
        BEGIN BRANCH "rst"
            WIRE 640 3200 656 3200
            WIRE 656 3200 976 3200
            WIRE 976 3056 976 3200
        END BRANCH
        BEGIN BRANCH "clk"
            WIRE 160 1920 336 1920
            BEGIN DISPLAY 336 1920 ATTR "Name"
                ALIGNMENT SOFT-LEFT
            END DISPLAY
        END BRANCH
        IOMARKER 160 1920 "clk" R180 28
        BEGIN BRANCH "clk"
            WIRE 2992 3040 2992 3088
            BEGIN DISPLAY 2992 3088 ATTR "Name"
                ALIGNMENT SOFT-VRIGHT
            END DISPLAY
        END BRANCH
        IOMARKER 512 2192 "signedOp_in" R180 28
        IOMARKER 512 2464 "multiplier_dividen_in(31:0)" R180 28
        IOMARKER 512 2608 "multiplicand_divider_in(31:0)" R180 28
        IOMARKER 512 2336 "op_in" R180 28
        IOMARKER 640 3200 "rst" R180 28
        IOMARKER 4528 2784 "hi_out(31:0)" R0 28
        IOMARKER 4528 2848 "lo_out(31:0)" R0 28
        IOMARKER 1664 2448 "busy" R0 28
        BUSTAP 304 2864 400 2864
    END SHEET
END SCHEMATIC
