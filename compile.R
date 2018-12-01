library(conveniencefunctions)
library(rmarkdown)

rmds <- list.files("rmds/", pattern = "[Rr]md")

htmls <- list.files("html/", "html$")

not_yet_rendered <- rmds[!str_detect(rmds, str_remove_all(htmls, "html"))]

to_render <- not_yet_rendered
to_render <- "defineinsertbranch.Rmd"

walk(to_render, ~rmarkdown::render(file.path("rmds", .x), 
                               output_format = "html_document", 
                               output_file = paste0(str_replace_all(.x, "[Rr]md", "html")), 
                               output_dir = "html"))


# ------------------------------------------------------------- #
# cleanup ----
# ------------------------------------------------------------- #
folders <- list.dirs("rmds/") %>% str_subset("trial")
unlink(folders, recursive = T)

# ------------------------------------------------------------- #
# index.html ----
# ------------------------------------------------------------- #

htmls2 <- list.files("html/", "html$")
htmls2 %>% paste0("[", ., "]", "(html/", ., ")") %>% paste0(collapse = "\n\n") %>% paste0("\n\n") %>% writeLines("index.md")
system2("pandoc", c("-o index.html", "index.md"))


git2r::add(".", "index.html")
git2r::commit(message = "update index")
system2("git", "push")


htmls2 %>% paste0("[", ., "]", "(html/", ., ")") %>% paste0(collapse = "\n\n") %>% paste0("\n\n") %>% writeLines("Readme.md")
git2r::add(".", "Readme.md")
git2r::commit(message = "update readme")
system2("git", "push")
