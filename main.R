library(rmarkdown)

clean_site()
post_rmd_files <- list.files('_posts', 
                             pattern = '.Rmd', 
                             recursive = TRUE, 
                             full.names = TRUE)
for (i in seq_along(post_rmd_files)) {
  render(post_rmd_files[i])
}
render_site()
