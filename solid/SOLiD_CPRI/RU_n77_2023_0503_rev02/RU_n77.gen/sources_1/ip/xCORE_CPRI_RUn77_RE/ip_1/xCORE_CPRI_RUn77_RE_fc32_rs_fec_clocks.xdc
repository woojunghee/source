
# Clock domain crossing for generic synchronizers
set_false_path -to [get_cells -hierarchical -filter {name =~ */someregs.ranks[*].i_syncer_rank/rank1_reg[*]*}]
