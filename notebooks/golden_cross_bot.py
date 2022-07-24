import blankly
from blankly import Alpaca, Interface, Strategy, StrategyState
from blankly.indicators import sma


def init(symbol, state: StrategyState):
    interface: Interface = state.interface
    resolution: float = state.resolution
    variables = state.variables
    # initialize the historical data
    variables["history"] = interface.history(symbol, 800, resolution, return_as='deque')["close"]
    variables["has_bought"] = False


def price_event(price, symbol, state: StrategyState):
    interface: Interface = state.interface
    # allow the resolution to be any resolution: 15m, 30m, 1d, etc.
    resolution: float = state.resolution
    variables = state.variables

    variables["history"].append(price)

    longSMA = sma(variables["history"], period=26)
    shortSMA = sma(variables["history"], period=12)[-len(longSMA):]
    diff = shortSMA - longSMA
    # slope_shortSMA = (
    #     shortSMA[-1] - shortSMA[-5]
    # ) / 5  # get the slope of the last 5 shortSMA Data Points
    prev_diff = diff[-2]
    curr_diff = diff[-1]
    # is_cross_up = slope_shortSMA > 0 and curr_diff >= 0 and prev_diff < 0
    # is_cross_down = slope_shortSMA < 0 and curr_diff <= 0 and prev_diff > 0
    is_cross_up = curr_diff >= 0 and prev_diff < 0
    is_cross_down = curr_diff <= 0 and prev_diff > 0
    # comparing prev diff with current diff will show a cross
    if is_cross_up and not variables["has_bought"]:
        interface.market_order(symbol, 'buy', int(interface.cash / price))
        variables["has_bought"] = True
    elif is_cross_down and variables["has_bought"]:
        interface.market_order(
            symbol, 'sell', int(interface.account[symbol].available)
        )
        variables["has_bought"] = False


if __name__ == "__main__":
    exchange = blankly.Alpaca()
    strategy = blankly.Strategy(exchange)
    strategy.add_price_event(price_event, "QQQ", resolution="1h", init=init)
    if blankly.is_deployed:
        strategy.start()
    else:
        strategy.backtest(to='1y', initial_values={'USD': 10000})


    
