import numpy as np
from scipy.stats.stats import pearsonr
from Config import SortedConfig


def CorelateNumbers(arr1, arr2):
    '''
    :param arr1: array1 of Numbers
    :param arr2: array2 of Numbers
    :return: Pearson coefficient that determines the corelation between the 2 arrays
    Conditions:  If the disaprity of size between 2 arrays length is very high then return -1 i.e. the length differ by a third
    and if the minimum length less than the threshold
    '''
    l1 = len(arr1)
    l2 = len(arr2)

    if max((l1 / l2), (l2 / l1)) < SortedConfig.CoRelationLengthThreshold and min(l1,
                                                                                  l2) < SortedConfig.CoRelationLengthDisparityThreshold:
        return -1
    else:
        m = min(l1, l2)
        return pearsonr(arr1[:m], arr2[:m])[0]
