
import pandas as pd
from statsmodels.tsa.holtwinters import ExponentialSmoothing

def time_series_predict(data,tolerance_level=10):
    '''
    The data must consist of only one column i.e. the time series data ordered in ascending order of their time.
    The tolerance level is used to adust the upper and lower bound of the prediction. by default the tolearnce band is
    considered as 10%.The output will be an array [predicted,upper_bound,lower_bound]
    '''
    temp_dict={}
    temp_dict['analysis']=data
    dataframe=pd.DataFrame(temp_dict)
    model = ExponentialSmoothing(dataframe['analysis'])
    model_fit = model.fit( optimized=True,use_boxcox=True, remove_bias=True)
    pred=model_fit.predict()
    pd.to_numeric(pred, errors='coerce')
    output=[pred]
    output.append(pred*(1+(tolerance_level/100)))
    output.append(pred*(1-(tolerance_level/100)))
    return output