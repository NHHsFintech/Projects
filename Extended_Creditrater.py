

### EXTENSION WITH CREDIT-RISK-PREMIUM ###


# USER INPUT OF ACCOUNTING FIGURES

LG1_ = float(input("Skriv inn likviditetsgrad 1: "))
RDG_ = float(input("Skriv inn rentedekningsgrad: "))
EKP_ = float(input("Skriv inn egekapitalprosenten: "))
NDR_ = float(input("Skriv inn netto driftsrentabilitet: "))

# LISTS WITH INTERVALS

list_acc_figures = [LG1_, RDG_, EKP_, NDR_]
list_LG1 = [0.3, 0.4, 0.5, 0.6, 0.9, 1.2, 1.7, 3, 6.2, 11.6]
list_RDG = [-4.1, -1.58, -0.76, 0.07, 0.9, 1.22, 2.16, 3.35, 6.3, 16.9]
list_EKP = [1.8, 2, 8, 13, 22, 32, 44, 66, 85, 94]
list_NDR = [-7.2, -4.4, -1.6, 1.2, 4, 6.8, 9.6, 16.6, 26.6, 35]
list_accounting_figures = [list_LG1, list_RDG, list_EKP, list_NDR]

# DICITIONARY WITH WEIGHTS FOR EACH CREDIT-RATING

list_weight = {'D':1,
              'C':2,
              'CC':3,
              'CCC':4,
              'B':5,
              'BB':6,
              'BBB':7,
              'A':8,
              'AA':9,
              'AAA':10
               }

# FUNCTION FOR RETURNING THE ACCOUNTING FIGURE TO A RATING

def rating(figure_list, Accounting_figure):
    i = 0
    list_ratings = ['D', 'C', 'CC', 'CCC', 'B', 'BB', 'BBB', 'A', 'AA', 'AAA']

    while Accounting_figure >= figure_list[i]:
        i += 1
        if i == 10:
            break
    rating_letter = list_ratings[i - 1]
    return rating_letter


# SIMPLE LIST FOR MATCHING NUMBERS WITH LETTERS
list_conversion = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

# GENERATION OF RESULTS THROUGH A FOR LOOP

l = 0
for i, value in enumerate(list_acc_figures):
    rating(list_accounting_figures[i], value)
    l += list_weight[rating(list_accounting_figures[i], value)]
mean_conv = l / len(list_acc_figures)

# PRINTING OF CREDIT-RATING RESULTS

print('\n Synthetic credit-rating: ' + rating(list_conversion, mean_conv).upper())



# ADDING SECTION FOR CREDIT RISK PREMIUM

final_rating = rating(list_conversion, mean_conv).upper()
ratings_for_CRP = ['D', 'C', 'CC', 'CCC', 'B', 'BB', 'BBB', 'A', 'AA', 'AAA']
list_CRP = [0.28, 0.214, 0.149, 0.083, 0.044, 0.031, 0.014, 0.010, 0.008, 0.006]

for i in range(0,10):
    if final_rating == ratings_for_CRP[i]:
        CRP_value = list_CRP[i]
print('\n Synthetic credit risk premium: ' + str(CRP_value))

prob_bankruptcy = CRP_value/list_CRP[0]
print('\n Synthetic probability of bankruptcy: ' + str(round(prob_bankruptcy*100,2)) + "%")