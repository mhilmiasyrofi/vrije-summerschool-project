install.packages("rjson")
library("rjson")

fileName = "trial.json"
conn <- file(fileName,open="r")
linn <-readLines(conn)
for (i in 1:length(linn)){
  if (i == 1) {
    js = fromJSON(linn[i])
    df<-data.frame(js$asin, js$summary, js$reviewText)
    names(df) = c("ID", "Rating", "Review")
  } else {
    js = fromJSON(linn[i])
    de<-data.frame(js$asin, js$summary, js$reviewText)
    names(de) = c("ID", "Rating", "Review")
    newdf = rbind(df, de)
    df = newdf
  }
}
close(conn)

View(head(df))
