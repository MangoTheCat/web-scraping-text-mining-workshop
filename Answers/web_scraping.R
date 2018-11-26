library(rvest)
simpleHtml <- read_html("<html><head>
<title>This is my title</title>
                        </head>
                        <body>
                        <p>This is in the main body of my website. </p>
                        </body>
                        </html>
                        ")
simpleHtml

localHtml <- read_html("Web Scraping and Text Mining/web-scraping-text-mining-workshop/r-project.html")
localHtml

mangoBlog <- read_html("https://www.mango-solutions.com/blog/2017/02")
mangoBlog

# Exercise 1
webscraping <- read_html("Web Scraping and Text Mining/web-scraping-text-mining-workshop/webscraping.html")
webscraping

cran <- read_html("https://cran.r-project.org/")
cran

mangoNodes <- mangoBlog %>% html_nodes(".post-title")
mangoNodes
html_text(mangoNodes)

# Exercise 2
hyperlinks <- webscraping %>%  html_nodes("a") %>% html_text()
paragraphs <- webscraping %>% html_nodes("p") %>% html_text()

mangoNodes %>% html_nodes("a") %>%  html_attr("href")

html_name(mangoNodes)

births <- read_html("https://www.ssa.gov/oact/babynames/numberUSbirths.html")
birthNodes <- html_nodes(births, "table")
birthTable <- html_table(birthNodes[[2]])
birthTable
class(birthTable)

# Exercise 3
webscrapingTable <- webscraping %>% 
  html_nodes("table") %>% 
  purrr::pluck(1) %>% 
  html_table()
webscrapingTable


# Exercise 4
webscraping %>% html_nodes("td , th, p") %>% html_text()
webscraping %>% html_nodes("h2") %>% html_text()
webscraping %>% html_nodes("td a") %>% html_attr("href")
