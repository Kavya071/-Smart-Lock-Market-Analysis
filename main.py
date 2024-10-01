import requests
from bs4 import BeautifulSoup
import pandas as pd

base_url = "https://www.flipkart.com/search?q=smart+locks&otracker=search&otracker1=search&marketplace=FLIPKART&as-show=on&as=off&page="

# Initialize an empty list to store the scraped data
data = []

# Iterate over the first 20 pages
for page in range(1, 21):
    url = base_url + str(page)
    response = requests.get(url)
    soup = BeautifulSoup(response.content, "html.parser")

    # Find all the product listings on the current page
    product_listings = soup.find_all("div", class_="slAVV4")

    # Iterate over each product listing
    for index, listing in enumerate(product_listings, start=(page-1)*40+1):
        # Extract the brand name and model
        brand_name = listing.find("a", class_="wjcEIp").text.strip()
        


        # Extract the price
        price_element = listing.find("div", class_="Nx9bqj")
        if price_element:
            price = int(price_element.text.strip().replace("₹", "").replace(",", ""))
        else:
            price = None

        # Extract the rating
        rating_element = listing.find("div", class_="XQDdHH")
        if rating_element:
            rating = float(rating_element.text.strip())
        else:
            rating = None

        # Extract the rating count
        rating_count_element = listing.find("span", class_="Wphh3N")
        if rating_count_element:
            rating_count_str = rating_count_element.text.strip().replace("(", "").replace(")", "")
            rating_count = int(rating_count_str.replace(",", ""))  # Remove comma and convert to integer
        else:
            rating_count = None

        # Extract the review count (assuming it's the same as the rating count)
        review_count = rating_count

        # Extract the URL
        url = "https://www.flipkart.com" + listing.find("a", class_="wjcEIp")["href"]

        # Append the scraped data to the list
        data.append({
            "Brand Name": brand_name,
            "Price": price,
            "Rating": rating,
            "Rating Count": rating_count,
            "Review Count": review_count,
            "Ranking": index,
            "URL": url
        })

# Create a DataFrame from the scraped data
df = pd.DataFrame(data)

# Export the DataFrame to an Excel file
df.to_excel("flipkart_smart_locks.xlsx", index=False)