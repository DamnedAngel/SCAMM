; --------------------------------
; MnemoSyne-X Memory Bank 0
; --------------------------------

; --------------------------------
; Segment 0 (0x0000)
; --------------------------------
MNEMO_SEG_TEXTS1                         .equ     0
MNEMO_RES_THETRIALMBM_SEG                .equ     MNEMO_SEG_TEXTS1
MNEMO_RES_THETRIALMBM                    .equ     0x8400
MNEMO_RES_MSXDOSOVL_SEG                  .equ     MNEMO_SEG_TEXTS1
MNEMO_RES_MSXDOSOVL                      .equ     0x86e8

; --------------------------------
; Segment 4 (0x0004)
; --------------------------------
MNEMO_SEG_TEXTS2                         .equ     4
MNEMO_RES_PRINTINTERFACEH_SEG            .equ     MNEMO_SEG_TEXTS2
MNEMO_RES_PRINTINTERFACEH                .equ     0x8400
MNEMO_RES_HMMCTESTS_SEG                  .equ     MNEMO_SEG_TEXTS2
MNEMO_RES_HMMCTESTS                      .equ     0x86e4

; --------------------------------
; Segment 80 (0x0050)
; --------------------------------
MNEMO_SEG_PLACE1                         .equ     80
MNEMO_RES_BG1_0_SEG                      .equ     MNEMO_SEG_PLACE1
MNEMO_RES_BG1_0                          .equ     0x8400

; --------------------------------
; Segment 81 (0x0051)
; --------------------------------
MNEMO_SEG_00081                          .equ     81
MNEMO_RES_BG1_1_SEG                      .equ     MNEMO_SEG_00081
MNEMO_RES_BG1_1                          .equ     0x8400

; --------------------------------
; Segment 82 (0x0052)
; --------------------------------
MNEMO_SEG_00082                          .equ     82
MNEMO_RES_BG1_2_SEG                      .equ     MNEMO_SEG_00082
MNEMO_RES_BG1_2                          .equ     0x8400

