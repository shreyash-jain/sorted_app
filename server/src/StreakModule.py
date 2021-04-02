def streakDataAnalyze(arr, analyze_ele):
    '''

    :param arr: The array containing the streak information in form of strings
    :param analyze_ele: Which ele of streak is to be considered for analysis
    :return: length of longest streak, start of longest streak,current streak length
    in case start of longest streak -1 it means it does not exisist

    '''
    long_streak = 0
    long_streak_start = -1
    temp_streak = 0
    n = len(arr)
    for i in range(n):
        if arr[i] == analyze_ele:
            temp_streak += 1
            if temp_streak > long_streak:
                long_streak = temp_streak
                long_streak_start = i - long_streak + 1
        else:
            temp_streak = 0
    current_streak = 0
    j = n - 1
    while j >= 0 and arr[j] == analyze_ele:
        current_streak += 1
        j -= 1
    return [long_streak, long_streak_start, current_streak]
