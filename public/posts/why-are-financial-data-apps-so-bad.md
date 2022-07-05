Why are financial data apps so bad?  
Michael Sjoeberg  
June 26, 2021  
July 5, 2022

Ok, some apps are fairly good (but this title is more catchy). I actively maintain about 50 financial models, primarily companies with products in the internet and internet-software domains (think Google and Microsoft, but not Apple). I frequently try new apps, and made multiple attempts to build myself. There are however two constants that seem irreplaceable: [EDGAR](https://www.sec.gov/edgar/searchedgar/companysearch.html) (company filings, sometimes replacable with well-designed and trustworthy investor relations page) and [Yahoo Finance](https://finance.yahoo.com/) (for everything else, it's the most reliable data provider).

## Alternatives to Yahoo Finance

The first thing I do when trying a new financial data app is to check range and availability of data; such as searching for tickers, and most have support for US exchanges, but not all support foreign exchanges, such as searching for Tencent, one of the largest companies in the world, and even fewer support Capcom, NAVER, Kakao, or Prosus (also very large non-US companies). Yahoo Finance support all of these.

**[Finviz](https://finviz.com/)**

Finviz provides a lot of data for US companies, but none of the user interface. The screener is useful to get a lot of data on several companies at once but limited to US exchanges. Finviz need to provide data on non-US companies to be considered as an alternative to Yahoo Finance.

**[Atom Finance](https://atom.finance/)** 

Atom Finance provides data for US companies, and a lot of visuals, but gives several unwanted result when searching for non-US companies, such as Tencent (a long list of pages, but not 0700.HK or TCEHY), similarily no correct results for Capcom (9697.T), or Kakao (035720.KS). Atom Finance need to provide data on non-US companies and clean up the search results to be considered as an alternative to Yahoo Finance. 

**[Koyfin](https://www.koyfin.com/)**

Koyfin is better than both Finviz and Atom Finance at providing data, and gives correct results for non-US-listed companies, but the user interface is an absolute mess (Yahoo Finance feels cleaner and faster). Koyfin need to improve the user interface to be considered as an alternative to Yahoo Finance.

**[Finbox](https://finbox.com/)**

Finbox provides data on US and non-US companies, and has a customizable interface (hide/show and move data widgets). However, plan starts at USD 19 per month with only US and Europe-listed companies (49 exchanges), adding more exchanges increase the price a lot (up to USD 80 per month). This is the best alternative to Yahoo Finance, but at a very steep price for data (unless interested in additional features). For example, if price is all you want, the [Marketstack API](https://marketstack.com/product) with 70 exchanges is USD 9.99 per month, or free with limited usage).

## A better alternative to Yahoo Finance

I want useful data (and preferably not more than that), as fast and cheap as possible, and in a distraction-free user interface. The first problem faced by most apps is to provide *useful* data (assuming most investors are looking for different data), this can be solved by providing *any* data (or as much as possible) and ask users to choose. The second problem is to provide a user-interface that is distraction-free (a distraction is anything unwanted in view), this can be solved by providing a highly customizable user-inteface (not just hide/show and move data widgets). I would be prepared to pay USD 50-150 per month, others maybe more, most important factor is data coverage and usability.

A good alternative would let users select and subscribe to data separately (data is considered useful), the app simply show what the user want in view. The user-interface is customizable as much as *feasible* (if something could be based on user-defined templates it should), including data (similar to formulas in spreadsheets).

**Stockstack (now at [terminal.frozenfork.com](https://terminal.frozenfork.com))**

I have made several attempts to build apps to improve my own workflow (equity research), first to move portfolio management tasks from spreadsheets to web (Modelmode.io, then EQZEN.com, both discontinued and reverted back to spreadsheets), then data aggregation tasks (an attempt to solve the previously-mentioned issues with alternatives to Yahoo Finance). This is the most recent attempt and started as a solution to view financial data on desktop (not in browser, similar to a terminal), using data provided by IEX Cloud (US-listed companies), and basically added features and additional data when needed (such as non-US companies via an unofficial Yahoo Finance API).

I then started to use an early version of this desktop-app for almost all data needs (only went to Yahoo Finance for data not yet implemented), and gives correct results for US and non-US companies, as well as currencies, and some crypto. It was initially designed to provide me with the data I most commonly want in a single view (no clicking around), but later transformed into providing *any* (available) data I want in the view (based on customizable templates).

The current state (as of July 5, 2022):

- Stock market data, watchlist, charts, news and other widgets in customizable views, each view is a combination of widgets and columns (subscribers only: all-in-one view to show widgets from all views)

- Select widgets and toggle data to show in each widget to make your views distraction-free. Additional widgets are available with your own API keys: Currently IEX Cloud (default and free), Yahoo Finance and SeekingAlpha via RapidAPI, and CoinMarketCap.

- Batch mode: Enter more than two symbols in search to use batch mode, show all data for a list of symbols (subscribers only)

- Tracker: Track symbol to show all data (persistent batch mode), convert non-base currency, and use portfolio features – set non-zero number to move symbol to portfolio

Subscription starting at USD 19.90 per month and increase limits on symbols in watchlist and tracker, chart range and interval, news items per symbol, up to ten views (both home and data pages), as well as batch mode.

Try for free here: [terminal.frozenfork.com](https://terminal.frozenfork.com).
