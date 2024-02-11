import scrapy


class ImdbSpiderSpider(scrapy.Spider):
    name = "imdb_spider"
    allowed_domains = ["www.imdb.com"]
    start_urls = ["https://www.imdb.com/chart/top/?ref_=nv_mv_250"]
    
    def start_requests(self):
        # Set a custom user-agent in the headers
        headers = {'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.36'}
        yield scrapy.Request(url='https://www.imdb.com/chart/top/?ref_=nv_mv_250', headers=headers, callback=self.parse)


    def parse(self, response):
        elements = response.css("div.ipc-metadata-list-summary-item__tc")
        for element in elements:
            yield{
                'Title' : element.css('div div a h3 ::text').getall(),
                'Year' : element.css('div div span ::text').getall(),
                'Rating' : element.css('div span span ::text').getall()
            }

