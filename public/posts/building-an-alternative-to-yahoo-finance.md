<!--
    Building an alternative to Yahoo Finance
    Michael Sjöberg
    June 26, 2021
-->

<!--
## <a name="1" class="anchor"></a> [Background](#1)
-->

##### Background

I actively maintain about 20 to 50 financial models, primarily companies with products in the internet/software domain (think Google and Microsoft, but not Apple). I have used several financial data applications (most briefly) and made multiple attempts to build alternatives myself. However, it is hard to beat [EDGAR](https://www.sec.gov/edgar/searchedgar/companysearch.html) for company filings, sometimes replaceable with well-designed and trustworthy investor relations page, and [Yahoo Finance](https://finance.yahoo.com/) for data (it is simply the most reliable source).

**The problem:** get useful data (and preferably not more than that), as fast and cheap as possible, and in a distraction-free user interface. The first issue with most applications listed below is to provide useful data (assuming most investors are looking for different data), this can be solved by providing any data (or as much as possible) and ask users to choose. The second issue is to provide a user-interface that is distraction-free (a distraction is anything unwanted in view), this can be solved by providing a highly customizable user-interface (not just hide/show and move data widgets). I would be prepared to pay between USD 25-150 per month, others maybe more, but most important factor is data coverage and usability.

<!--
## <a name="2" class="anchor"></a> [Financial data applications](#2)
-->

##### Testing financial data applications

The first thing to do when testing a financial data app is to check range and availability of data, such as searching for tickers, and while most have support for US exchanges, not all support certain foreign exchanges. For example, try searching for Tencent, one of the largest companies in the world, or maybe Capcom, NAVER, Kakao, or Prosus (also very large non-US companies). Yahoo Finance support all of these, so that is the benchmark. Below are a few alternatives and conclusion, as of June 26, 2021.

- **Finviz** provide a lot of data for US companies but unintuitive user interface. The screener is useful to get a lot of data on several companies at once but still limited to US exchanges.

- **Atom Finance** provide data for US companies and a lot of visuals but gives a lot of unwanted results when searching for non-US companies, such as Tencent (a long list of results, but not 0700.HK or TCEHY), similarly no results for Capcom (9697.T), or Kakao (035720.KS).

- **Koyfin** provide more data than others and gives accurate results for non-US-listed companies, but user interface is full of distractions (Yahoo Finance feels cleaner and faster).

- **Finbox** provide data on US and non-US companies, with a customizable user interface (hide, show, or move widgets). However, plan starts at USD 19 per month with only US and Europe-listed companies (49 exchanges in total), and adding more exchanges increase the price a lot (up to USD 80 per month).

<!--
## <a name="3" class="anchor"></a> [A better alternative](#3)
-->

##### A better Yahoo Finance alternative

I have made several past attempts to build applications to improve my own workflow (equity research), first to move portfolio management tasks from spreadsheets to web (but discontinued and went back to spreadsheets), then data aggregation tasks to solve some-mentioned issues with alternatives to Yahoo Finance. 

**The goal:** a good alternative to Yahoo Finance would let users select and subscribe to some (or all) data separately (then the data would be useful), the application should only show what is requested (in one or more view). The user-interface should be customizable as much as possible, such as user-defined templates, including data (like formulas in spreadsheets).

##### Introducing Terminal

My project: [Terminal](https://terminal.frozenfork.com) is my most recent attempt at this problem. It started as a solution to view financial data on desktop (not in browser, like a terminal), using data provided by IEX Cloud (mainly US-listed companies), and basically added features and additional data when needed (such as non-US companies via an unofficial Yahoo Finance API). I started to use an early version of this desktop-application for almost all data needs (only went to Yahoo Finance occasionally, and for data not yet implemented). It was initially designed to provide me with the data I usually want in a single view (no clicking around), but later transformed into providing any (available) data I currently want in views (based on customizable templates).

The current state (as of July 5, 2022):

- Stock market data, watchlist, charts, news and other widgets in customizable views, each view is a combination of widgets and columns (subscribers only: all-in-one view to show widgets from all views)

- Select widgets and toggle data to show in each widget to make your views distraction-free. Additional widgets are available with your own API keys: Currently support IEX Cloud (default and free), Yahoo Finance and SeekingAlpha via RapidAPI, and CoinMarketCap
	- adding API key for Yahoo Finance via RapidAPI gives same stock data coverage as Yahoo Finance website (there are free options)

- Batch mode: Enter more than two symbols in search to use batch mode, show all data for a list of symbols (subscribers only)

- Tracker: Track symbol to show all data (persistent batch mode), convert non-base currency, and use portfolio features – set non-zero number to move symbol to portfolio

Subscription starting at USD 19.90 per month and increase limits on symbols in watchlist and tracker, chart range and interval, news items per symbol, up to ten views (both home and data pages), as well as batch mode.
