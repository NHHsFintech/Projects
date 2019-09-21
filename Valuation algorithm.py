
print("**** COMPANY VALUATION****")

select_model = input("Select the valuation model. Options are GGM & DFCFF: ")

# If GGM valuation is selected, the calculations below are performed
if select_model == "GGM":
    wacc = float(input("Insert the weighted average cost of capital: "))
    g = float(input("Insert the steady state growth rate (cannot exceed the overall growth in economy): "))
    FCFF1 = float(input("Insert the expected cash flow next year: "))
    value_GGM = round(FCFF1/(wacc-g),2)
    print("The value of the company using GGM is: " + str(value_GGM))

# If discounted cash flow to the firm is selected, the calculations below are performed
elif select_model == "DFCFF":

    # Variable and list creation use for computations
    cash_flow_list = []
    discounted_list = []
    nr_cash_flows = int(input("Insert the number of cash flows before steady state: "))
    termination_CF = int(input("Insert the cash flow at steady state: "))
    wacc_constant = float(input("Insert the constant weighted average cost of capital: "))
    growth_DFCFF = float(input("Insert the expected growth from steady state: "))

    # Iteration for insertion of cash flows that were previously inserted by user
    for i in range(1,nr_cash_flows+1):
        cash_flow_iteration_i = int(input("Insert cash flow for period " + str(i) + ":"))
        cash_flow_list.append(cash_flow_iteration_i)

    # Iteration for computation of the fixed cash flows
    for i in range(0,len(cash_flow_list)):
        value_period = cash_flow_list[i]/(1+wacc_constant)**(i+1)
        discounted_list.append(value_period)

    # Stand-alone computation of termination value at steady state
    value_term = termination_CF / (((1 + wacc_constant) ** (len(cash_flow_list))) * (wacc_constant - growth_DFCFF))
    discounted_list.append(value_term)

    #print(discounted_list)

    # Sum up the discounted values and print of results
    print("The value of the company is: " + str(round(sum(discounted_list))))