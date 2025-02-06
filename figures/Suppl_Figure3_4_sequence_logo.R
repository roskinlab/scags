require(ggseqlogo)
library(stringr)

#alignment_input_path = path to multiple sequence alignment file obtained from muscle

seqlogo = function(alignment_input_path,output_path, name ){
  aln = read.delim(input_path, sep =' ', skip=3, header=F)
  aln=aln[!aln$V7=="", ]
  aln= aln[!grepl('\\*', aln$V7),]
  seq=aln$V7
  
  p1 = ggseqlogo(seq, method = 'bits' , seq_type='aa')+  
    theme(axis.text.x = element_blank(),axis.text.y = element_blank(), axis.title = element_blank() )+
    theme(legend.position = 'none')+
    theme(plot.margin=grid::unit(c(0,0,0,0), "mm"))
  ggsave(paste0(output_path, name, '.pdf', sep=''), plot=p1, width=2., height=0.34, device=cairo_pdf)
  ggsave(paste0(output_path,name ,'.png', sep=''),plot=p1, width=2.81, height=0.34)
  return(p1)
}

Cluster_logo = seqlogo('alignment_path', 'output_result_path', 'result_filename')
