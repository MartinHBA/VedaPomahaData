# https://github.com/Icefeast/VedaPomahaData/blob/main/CakarenOckovanie/data/sum.ipynb
import numpy as np
import pandas as pd
import sys

dflist = []
for num in range(int(sys.argv[1])):
    dfname = f'df{num+1}'
    dfname = pd.read_csv(f'D:\\OneDrive\\git\\VedaPomahaData\\CakarenOckovanie\\dataScheduled\\{num+1}.csv',encoding='utf-8')
    dfgrouped = dfname.groupby(['Dávka','Termín','Veková skupina','Čas publikovania']).sum('Počet registrácií')
    #dfgrouped.drop('Počet okresov registrácie',axis=1,inplace=True)
    #dfgrouped.drop_duplicates()
    dflist.append(dfgrouped)
result = pd.concat(dflist)
result.drop_duplicates()
result.to_csv('D:\\OneDrive\\git\\VedaPomahaData\\CakarenOckovanie\\terminyTrend.csv',encoding='utf-8')