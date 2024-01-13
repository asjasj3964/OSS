import pandas as pd

data = pd.read_csv('2019_kbo_for_kaggle_v2.csv')
selected_columns = ['batter_name', 'year', 'H', 'avg', 'HR', 'OBP']
dataFrame = pd.DataFrame(data, columns=selected_columns)

def print_top_10_players(category, year):
    yearData = dataFrame[dataFrame['year'] == year]
    top10 = yearData.nlargest(10, category)
    obj = top10.set_index('batter_name')[category]
    print(obj)
    print()

for year in range(2015, 2019):
    print_top_10_players('H', year)
    print_top_10_players('avg', year)
    print_top_10_players('HR', year)
    print_top_10_players('OBP', year)

data2018 = data[data['year'] == 2018]
highestWar = data2018.groupby('cp').apply(lambda x: x.loc[x['war'].idxmax()])
print(highestWar[['batter_name', 'cp', 'war']])
print()
correlationMatrix = data[['salary', 'R', 'H', 'HR', 'RBI', 'SB', 'war', 'avg', 'OBP', 'SLG']].corr()
print(correlationMatrix)
print()
corrVariable = correlationMatrix['salary'].idxmax()
corrValue = correlationMatrix.loc['salary', corrVariable]
print(corrVariable)
print(corrValue)
