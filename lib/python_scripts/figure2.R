# import R libraries
library(ggplot2)
library(ggthemes)
library(scales)
library(grid)
library(RColorBrewer)

# Multiple plot function
# Taken from http://www.cookbook-r.com/Graphs/Multiple_graphs_on_one_page_(ggplot2)/
#
# ggplot objects can be passed in ..., or to plotlist (as a list of ggplot objects)
# - cols:   Number of columns in layout
# - layout: A matrix specifying the layout. If present, 'cols' is ignored.
#
# If the layout is something like matrix(c(1,2,3,3), nrow=2, byrow=TRUE),
# then plot 1 will go in the upper left, 2 will go in the upper right, and
# 3 will go all the way across the bottom.
#
multiplot <- function(..., plotlist=NULL, file, cols=1, layout=NULL) {
  library(grid)
  
  # Make a list from the ... arguments and plotlist
  plots <- c(list(...), plotlist)
  
  numPlots = length(plots)
  
  # If layout is NULL, then use 'cols' to determine layout
  if (is.null(layout)) {
    # Make the panel
    # ncol: Number of columns of plots
    # nrow: Number of rows needed, calculated from # of cols
    layout <- matrix(seq(1, cols * ceiling(numPlots/cols)),
                     ncol = cols, nrow = ceiling(numPlots/cols))
  }
  
  if (numPlots==1) {
    print(plots[[1]])
    
  } else {
    # Set up the page
    grid.newpage()
    pushViewport(viewport(layout = grid.layout(nrow(layout), ncol(layout))))
    
    # Make each plot, in the correct location
    for (i in 1:numPlots) {
      # Get the i,j matrix positions of the regions that contain this subplot
      matchidx <- as.data.frame(which(layout == i, arr.ind = TRUE))
      
      print(plots[[i]], vp = viewport(layout.pos.row = matchidx$row,
                                      layout.pos.col = matchidx$col))
    }
  }
}


fte_theme <- function() {
  # Written by Max Woolf
  # https://minimaxir.com/2015/02/ggplot-tutorial/
  # Generate the colors for the chart procedurally with RColorBrewer
  palette <- brewer.pal("Greys", n=9)
  color.background = palette[2]
  color.grid.major = palette[3]
  color.axis.text = palette[6]
  color.axis.title = palette[7]
  color.title = palette[9]
  
  # Begin construction of chart
  theme_bw(base_size=9) +
    
    # Set the entire chart region to a light gray color
    theme(panel.background=element_rect(fill=color.background, color=color.background)) +
    theme(plot.background=element_rect(fill=color.background, color=color.background)) +
    theme(panel.border=element_rect(color=color.background)) +
    
    # Format the grid
    theme(panel.grid.major=element_line(color=color.grid.major,size=.25)) +
    theme(panel.grid.minor=element_blank()) +
    theme(axis.ticks=element_blank()) +
    
    # Format the legend, but hide by default
    theme(legend.position="none") +
    theme(legend.background = element_rect(fill=color.background)) +
    theme(legend.text = element_text(size=7,color=color.axis.title)) +
    
    # Set title and axis labels, and format these and tick marks
    theme(plot.title=element_text(color=color.title, size=12, vjust=1.25, face = "bold", hjust = 0.5)) +
    theme(axis.text.x=element_text(size=10,color=color.axis.text, face = "bold")) +
    theme(axis.text.y=element_text(size=10,color=color.axis.text, face = "bold")) +
    theme(axis.title.x=element_text(size=10,color=color.axis.title, vjust=0,face = "bold")) +
    theme(axis.title.y=element_text(size=10,color=color.axis.title, vjust=1.25, face = "bold")) #+
    
    # Plot margins
    #theme(plot.margin = unit(c(0.35, 0.2, 0.3, 0.35), "cm"))
}
# load count data file
dat <- read.csv("1011_genomes_count.txt", sep = '\t', header = TRUE)

# create a new data frame and convert counts to log2 scale
cntDat <- dat
cntDat$count <- log(cntDat$count,base = 2)

# original plot
ggplot(cntDat, aes(x=hits, y=count)) + geom_col(fill="#c0392b", alpha=0.8, width = 1) + 
  fte_theme() + labs(title="Logarithmic Distribution of sgRNA hits for 1011 Genomes, all CDS", x="Number of 1011 Genomes Hit", y="sgRNA Count") + 
  scale_x_continuous(breaks = seq(0,1020, by=250), limits = c(0,1020)) + 
  scale_y_continuous() +
  geom_hline(yintercept = 0, size=0.4, color="black")

# bin hits
binData <- dat
binData$bins <-cut(binData$hits, c(-Inf, 0, 111, 211,311,411,511,611,711,811,911,1012))
# convert to log 2 scale
binData$count <- log(binData$count, base=2)

binned <- ggplot(binData, aes(x=bins, y=count)) + geom_bar(stat = "identity",fill="#c0392b", alpha=0.8, width = 1) + 
  fte_theme() + labs(x="Number of 1011 Genomes Hit, all CDS", y="sgRNA Count") + 
  scale_x_discrete(labels=c("0","111", "211", "311", "411", "511", "611", 
                            "711",  "811", "911", "1011")) +
  scale_y_continuous() +
  geom_hline(yintercept = 0, size=0.4, color="black")

# show both plots on same page
multiplot(original, binned)































