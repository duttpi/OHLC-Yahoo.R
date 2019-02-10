
get.yahoo=function(ticker, years, frequency){
    # Covert to unix date
    today = as.character(Sys.Date())
    year = as.numeric(substr(today,1,4)) - years
    from = gsub(substr(today,1,4),year,today)
    today= as.numeric(as.POSIXct(paste(today,"EST")))
    from = as.numeric(as.POSIXct(paste(from,"EST")))
    period = list(daily = '1d', weekly= '1wk', monthly = '1mo')
    freq = period[[frequency]]

    # Create URL
    url = paste('https://query1.finance.yahoo.com/v7/finance/download/',
                ticker, '?period1=', 
                from, '&period2=', today, '&interval=', freq,
                '&events=history&crumb=G.coU0E9E.s', sep = "")

    # Get download folder directory
    dest = paste('C:/Users/',Sys.getenv("USERNAME"),
             '/Downloads/', ticker, '.csv', sep = "")
    
    # Download
    if(!file.exists(dest)) {
        browseURL(url)
    }else{
        file.remove(dest)
        browseURL(url)
        }

    # Read csv
    for(i in 1:3){
        if(!file.exists(dest)) {
            Sys.sleep(i)
        }else{
            stock = read.csv(dest)
            stock = na.omit(stock)
            file.remove(dest)
            break
        }
    }

    #  If download incomplete
    if (exists('stock') == FALSE)
        message('Unable to download')

    return(stock)
}

daily = get.yahoo('AAPL', 3, 'daily')
weekly = get.yahoo('AAPL', 5, 'weekly')
monthly = get.yahoo('AAPL', 10, 'monthly')


