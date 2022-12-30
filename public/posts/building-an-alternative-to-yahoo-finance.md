<!--
    Building an alternative to Yahoo Finance
    Michael Sjöberg
    June 26, 2021
-->

## <a name="1" class="anchor"></a> [Background](#1)

I actively maintain about 20 to 50 financial models, primarily companies with products in the internet/ software domain, think Google and Microsoft but not Apple. I have used several financial data applications (most briefly) and made multiple attempts to build alternatives myself. However, it is hard to beat [EDGAR](https://www.sec.gov/edgar/searchedgar/companysearch.html) for company filings, sometimes replaceable with well-designed and trustworthy investor relations page, and [Yahoo Finance](https://finance.yahoo.com/) for data. Yahoo is simply the most reliable source. The problem is to get useful data, but preferably not more than that, as fast and cheap as possible, and in a distraction-free user interface. The first issue with most applications listed below is to provide useful data (assuming most investors are looking for different data), this can be solved by providing any data, or as much as possible, and ask users to choose. The second issue is to provide a user-interface that is distraction-free, where a distraction is anything unwanted in view. This can be solved by providing a highly customizable user-interface, not just hide/ show and move widgets. I would be prepared to pay between USD 25-150 per month, others maybe more, but most important factor is data coverage and usability.

## <a name="2" class="anchor"></a> [Testing financial data applications](#2)

The first thing to do when testing a financial data app is to check range and availability of data, such as searching for tickers, and while most support tickers on US exchanges, not all support foreign exchanges. For example, coverage for Tencent, one of the largest companies in the world, or maybe Capcom, NAVER, Kakao, or Prosus, which are all very large non-US companies. Yahoo Finance support all of these, so it is the benchmark. Below are a few alternatives and comments (as of June 26, 2021).

- **Finviz** is a good tool and provide a lot of data for US-listed companies but unintuitive user interface. The screener is useful to get a lot of data on several companies but limited to US exchanges.

- **Atom Finance** provide good data for US-listed companies and a lot of visuals but also a lot of unwanted results when searching for non-US companies, such as Tencent, which gives a long list of results but not 0700.HK or TCEHY, and no results for Capcom (9697.T), or Kakao (035720.KS).

- **Koyfin** provide more data than many other and accurate results for non-US-listed companies, but user interface is full of distractions. It is probably the best alternative though.

- **Finbox** provide data on US-listed and companies on many foreign exchanges, with a customizable user interface (hide/ show and move widgets). However, plan starts at USD 19 per month with only US and Europe-listed companies (49 exchanges in total), and adding more exchanges is fairly expensive (up to USD 80 per month).

## <a name="3" class="anchor"></a> [A better Yahoo Finance alternative](#3)

I have made several past attempts to build applications to improve my own workflow for equity research, first to move portfolio management tasks from spreadsheets to web (but discontinued and went back to spreadsheets), then data aggregation tasks to solve some of the above mentioned issues with Yahoo Finance and its alternatives. A good alternative to Yahoo Finance would let users select and subscribe to some or all data separately, which makes the data useful. The interface should only show what is requested in one or more views (preferably less). The interface should be customizable as much as possible, such as user-defined templates, including data input like formulas in spreadsheets.

#### <a name="4" class="anchor"></a> [My solution](#3.1)

[Terminal](https://terminal.frozenfork.com) is my most recent attempt at this problem. It started as a solution to view financial data on desktop (not in browser), using data provided by IEX Cloud, which had mainly US-listed companies, and basically added features and additional data when needed, such as non-US companies via an unofficial Yahoo Finance API. I started to use an early version of this desktop-application for almost all data needs and only went to Yahoo Finance for data not yet implemented. It was initially designed to provide me with the data I usually want in a single view, so no clicking around, but later transformed into providing any available data I currently want in views based on customizable templates.

The current state (as of July 5, 2022):

- Stock market data, watchlist, charts, news and other widgets in customizable views, each view is a combination of widgets and columns (subscribers only: all-in-one view to show widgets from all views)

- Select widgets and toggle data to show in each widget to make your views distraction-free. Additional widgets are available with your own API keys: Currently support IEX Cloud (default and free), Yahoo Finance and SeekingAlpha via RapidAPI, and CoinMarketCap
	- adding API key for Yahoo Finance via RapidAPI gives same stock data coverage as Yahoo Finance website (there are free options)

- Batch mode: Enter more than two symbols in search to use batch mode, show all data for a list of symbols (subscribers only)

- Tracker: Track symbol to show all data (persistent batch mode), convert non-base currency, and use portfolio features – set non-zero number to move symbol to portfolio

Subscription available at USD 19.90 per month to increase limits on symbols in watchlist and tracker, chart range and interval, news items per symbol, up to ten views (both home and data pages), as well as batch mode.
