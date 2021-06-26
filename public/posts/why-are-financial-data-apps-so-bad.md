Why are financial data apps so bad?  
Michael Sjoeberg  
June 26, 2021  
June 26, 2021  

Ok, some apps are good (but this title is more catchy). I actively maintain about 50 financial models, primarily companies with products in the internet and internet-software domains (think Google and Microsoft, but not Apple). I frequently try new apps, and even tried to build some myself, more on that later. There are however two constants that seem irreplaceable: SEC Edgar company search (for filings) and Yahoo Finance (for everything else). That I still feel the need to use Yahoo Finance is annoying, but very easy to explain after trying other financial apps. It's better.

## Why is Yahoo Finance better?

The first thing I do on a new financial app (read: financial data aggregator) is to check availability of data; such as searching for tickers, and most return some pre-selected data on US-listed companies, but fewer results for companies such as Tencent, the seventh-largest company in the world (according to [CompaniesMarketCap](https://companiesmarketcap.com/); as of today), as well as Capcom, NAVER, Kakao, or Prosus. These are not really small companies, and they are all public, most apps just fail to provide that data, forcing me to go back to Yahoo Finance. Anyway, below are what I believe the best non-professional financial data apps:

**Finviz**

Finviz screener is useful to get a lot of data on several companies at once but have to use  Yahoo Finance for the non-US-listed ones (which gets even worse when converting data in local currencies into USD, Yahoo should definitely provide a feature to convert some currency into any other currency).

**Atom Finance** 

Atom Finance is great but gives me atleast one unwanted result when searching for Tencent (should be: 0700.HK or TCEHY), INVSTR (whatever that is), no results for Capcom (should be: 9697.T), or Kakao (should be: 035720.KS), and so on. Yahoo Finance have no problem to find these.

**Koyfin**

Koyfin is better than Finviz and Atom Finance at providing data, and gives correct results for non-US-listed companies, but it's clunky and not very fast (even Yahoo Finance feels cleaner and faster, imagine that!). To be fair, they do market themselves as an analytics business, so might not be a perfect match.

**Tradingview**

Tradingview is a very popular charting tool, and show correct results for non-US-listed companies, which I consider the bare minimum. However, it's just as busy as Koyfin, and focus is on charting, and some other social features (there are even small red Facebook-style notifications, not very distraction-free!). This is obviously not something I would use, and I get stressed just by looking at it.

**Finbox**

Finbox is probably the best of the above, provide most data, as well as support for customizing the interface (hide and show widgets). However, plan starts at USD 19 per month with only US-listed companies, and very few additional features, such as fair value estimates (which I strongly believe is misleading and impossible, but not important for this comparison), adding more regions increase the price a lot. I would probably use this app if I ever wanted the additional features (highly unlikely), but otherwise very steep price for data. For example, adding all regions to plan is USD 99 per month (compared with [Marketstack API](https://marketstack.com/product) with 70 exchanges for USD 9.99 per month, or USD 0 with limited usage).

## What I want

I want whatever data I need and find interesting (and preferably not more than that), as fast and cheap as possible, and in a distraction-free environment. The first hard problem is to define *interesting*. So, how to provide *interesting* data to investors (such as myself), as fast and cheap as possible, and without distractions (distraction is anything not wanted in view)? I would probably pay between USD 10 and 100 for this, others maybe more (I am likely biased since I can build my own apps).

A solution would be to let users (read: investors) select and subscribe to data separately (data should always be relevant and therefore interesting); let users connect app with data provider (via API); and app would simply display the data, or subset of data, whatever the user wants to see. The interface should be customizable (as in select this or that data to show, like Finbox) and data should be manipulatable (as in creating new data with other data, like formulas in spreadsheets).

**My solution: Stockstack**

I have previously experimented with building apps to improve my workflow, first an attempt to move portfolio management tasks from spreadsheets to web-app (Modelmode.io, then EQZEN.com, both discontinued), then switched focus to data aggregation tasks (to solve the above-mentioned issues with already available apps). Stockstack started as a solution to view financial data as a desktop-app (conveniently sized and placed next to spreadsheets for optimal workflow), fetching data from IEX Cloud API, and basically adding features and data when needed. I have recently started using an early version of this app for almost all data needs (only tab to Yahoo Finance for data not yet implemented or potentially incorrect), and it gives correct results for non-US-listed companies, currencies, and crypto. It is designed to provide me with the data I most commonly want in a single view (no clicking around).

The current state of Stockstack (alpha) provides a fast and distraction-free view of pre-selected data (via IEX Cloud and Yahoo Finance APIs). Next steps:

- Modular interface (predict style and format based on selected data) and make it possible to create custom templates with user-selected data. **This solves the problem with distraction (user choose what to see)**

- Edit and create new data (based on already available data). **This solves problem with predicting what users want, such as different ratios, or alternative definition of cash**

- API wrapper for popular data providers; users select and provide API-key to be able to select and use that data in the app. **This solves problem with predicting what data is interesting or useful for users** (i.e. features and data to show in app depends on the data available via the selected API, with eventual support for more than one API)

I'm hopefully ready to release Stockstack beta in Q3 2021 (several data providers; desktop and web), maybe later, we'll see. Pricing will likely include free-plan (with own API-key), USD 10 per month for basics (I provide API-key), USD 5 per month per additional API-keys (one is free, so this plan starts at USD 10), this is useful if you need more than one data provider (to build custom data via formulas or verify correctness), and USD 1000 + USD 25 per month for custom API integration. This might change in the future.
