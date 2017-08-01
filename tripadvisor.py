from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.common.exceptions import NoSuchElementException
import time
import csv

driver = webdriver.Chrome()
driver.get("https://www.tripadvisor.com/Restaurants-g60763-zfn29504-New_York_City_New_York.html#EATERY_OVERVIEW_BOX")

csv_file = open('reviews.csv','w')
writer = csv.writer(csv_file) 
writer.writerow(['name', 'stars', 'num_reviews', 'price', 'cuisine'])

while True:
	try:
		reviews = driver.find_elements_by_xpath('.//div[@id="EATERY_SEARCH_RESULTS"]//div[@data-index]')
		for review in reviews:
			review_dict = {}

			name = review.find_element_by_xpath('.//a[@class="property_title"]').text
			try:
				stars = review.find_element_by_xpath('.//div[@class="rating rebrand"]/span').get_attribute('alt')
			except NoSuchElementException:
				stars = ''
			try:
				num_reviews = review.find_element_by_xpath('.//span[@class="reviewCount"]').text
			except NoSuchElementException:
				num_reviews = ''
			try:
				price = review.find_element_by_xpath('.//span[@class="item price"]').text
			except NoSuchElementException:
				price = ''
			try:
				cuisine = review.find_element_by_xpath('.//a[@class="item cuisine"]').text
			except NoSuchElementException:
				cuisine = ''

			review_dict['name'] = name
			review_dict['stars'] = stars
			review_dict['num_reviews'] = num_reviews
			review_dict['price'] = price
			review_dict['cuisine'] = cuisine
			writer.writerow(review_dict.values())

		driver.execute_script("window.scrollTo(0, document.body.scrollHeight);")
		button = driver.find_element_by_link_text('Next')
		button.click()
		time.sleep(2)
	except Exception as e:
		print(e)
		csv_file.close()
		driver.close()
		break
