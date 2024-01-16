



1. Virtual Memory
   1. The Scamm Virtual Memory System (SVMS) Allows to:
      1. Activate a 16kb Scamm Data Pack (SDP) is loaded in a Memory Mapper (MM) segment.
         1. Receive the SDP Handler from the application.
         2. Retrieve MM Segment index from SDP Handler.
         3. Check whether MM Segment index from SDP Handler is Zero. If it is, goto |SelectSegment|.
         2. Retrieve SDP Id from SDP Handler.
         4. Check if MM Segment table associates SDP Id with Segment index from SDP Handler. If it doesn't, goto |SelectSegment|.
         5. Check if SDP header in segment matches SDP Id. If it doesn't, **LOG** and goto |SelectSegment|.
         6. Update the MM segment table with Status Active.
         7. Return.
         8. |SelectSegment|
         9.  Check whether there is at least one available MM segment. If there is goto |LoadSDP|.
         10. Check whether there is at least one inactive MM segment. If there isn't, abends the program.
         11. |LoadSDP|
         12. Load SDP in selected MM segment.
         13. Update the MM segment table with SDP Id and Status Active.
         14. Update SDP Handler with MM segment index.
         15. Return.
      2. Deactivate SDP.
         1. Receive the SDP Handler from the application.
         2. Retrieve MM Segment index from SDP Handler.
         3. Check whether MM Segment index from SDP Handler is Zero. If it is, **LOG** and return.
         4. Retrieve SDP Id from SDP Handler.
         5. Check if MM Segment table associates SDP Id with Segment index from SDP Handler. If it doesn't, **LOG** and return.
         6. Update the MM segment table with Status inactive.

   2. SDP Handler Structure
      1. .db _segment
      2. .dw _SDPId
   
   3. Mapped Pointers Structure
      1. .db _segment
      2. .dw _address (Page2-based (0x8000-0xb000))
   
   4. The MM Segment Table Structure
      1. 256 entries of (total 1kb):
         1. .dw _SDPId
         2. .db _status
            1. bit 0:   0=inactive, 1=active        (LSB)
            2. bit 1:   Reserved
            3. bit 2:   Reserved
            4. bit 3:   Reserved
            5. bit 4:   Reserved
            6. bit 5:   Reserved
            7. bit 6:   Reserved
            8. bit 7:   0=SVMS, 1=Other             (MSB)
         3. .db _reserved

