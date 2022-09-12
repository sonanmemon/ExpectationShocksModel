using QuantEcon
using LinearAlgebra, Statistics
using DataFrames, Parameters, Plots, Printf, QuantEcon, Random
#using PyPlot
#using Pkg
#Pkg.add("StatsBase")
using StatsBase
using Dates
using LaTeXStrings
gr(fmt = :png);
using Distributions
using CSV

df = CSV.read("C:\\Users\\ND.COM\\Desktop\\PIDE\\Research\\Expectation Shocks in a Macro Model\\expectation_shock.csv", DataFrame)

df4period = CSV.read("C:\\Users\\ND.COM\\Desktop\\PIDE\\Research\\Expectation Shocks in a Macro Model\\expectation_shock4period.csv", DataFrame)

df4periodoutputpref = CSV.read("C:\\Users\\ND.COM\\Desktop\\PIDE\\Research\\Expectation Shocks in a Macro Model\\expectation_shock4period_outputpref.csv", DataFrame)

dfpermanentshock = CSV.read("C:\\Users\\ND.COM\\Desktop\\PIDE\\Research\\Expectation Shocks in a Macro Model\\expectations_permanentshock.csv", DataFrame)

df3temporaryshocks = CSV.read("C:\\Users\\ND.COM\\Desktop\\PIDE\\Research\\Expectation Shocks in a Macro Model\\expectation_seriesofshocks.csv", DataFrame)


df4periodphi95 = CSV.read("C:\\Users\\ND.COM\\Desktop\\PIDE\\Research\\Expectation Shocks in a Macro Model\\expectation_shock4period_phi0.95.csv", DataFrame)

df4periodphi05 = CSV.read("C:\\Users\\ND.COM\\Desktop\\PIDE\\Research\\Expectation Shocks in a Macro Model\\expectation_shock4period_phi0.05.csv", DataFrame)


df4periodalpha4 = CSV.read("C:\\Users\\ND.COM\\Desktop\\PIDE\\Research\\Expectation Shocks in a Macro Model\\expectation_shock4periodalpha4.csv", DataFrame)

df4periodalpha05 = CSV.read("C:\\Users\\ND.COM\\Desktop\\PIDE\\Research\\Expectation Shocks in a Macro Model\\expectation_shock4periodalpha0.05.csv", DataFrame)


print(df4period)
print(df3temporaryshocks)

#describe(df())
#print(describe(df()))

xaxis=1:1:50
xaxisnew = 1:1:60

inflation = df."Inflation (%)"
inflation_model2 = df4period."Inflation (%)"
inflation_model3 = dfpermanentshock."Inflation (%)"
inflation_model4 = df3temporaryshocks."Inflation (%)"
inflation_model5 = df4periodoutputpref."Inflation (%)"
inflation_model6 = df4periodphi95."Inflation (%)"
inflation_model7 = df4periodphi05."Inflation (%)"
inflation_model8 = df4periodalpha05."Inflation (%)"
inflation_model9 = df4periodalpha4."Inflation (%)"
print(inflation)

output = df."Output"
output_model2 = df4period."Output"
output_model3 = dfpermanentshock."Output"
output_model4 = df3temporaryshocks."Output"
output_model5 = df4periodoutputpref."Output"
output_model6 = df4periodphi95."Output"
output_model7 = df4periodphi05."Output"
output_model8 = df4periodalpha05."Output"
output_model9 = df4periodalpha4."Output"


nominal_interest = df."Nominal Interest Rate"
nominal_interest_model2 = df4period."Nominal Interest Rate"
nominal_interest_model3 = dfpermanentshock."Nominal Interest Rate"
nominal_interest_model4 = df3temporaryshocks."Nominal Interest Rate"
nominal_interest_model5 = df4periodoutputpref."Nominal Interest Rate"
nominal_interest_model6 = df4periodphi95."Nominal Interest Rate"
nominal_interest_model7 = df4periodphi05."Nominal Interest Rate"
nominal_interest_model8 = df4periodalpha05."Nominal Interest Rate"
nominal_interest_model9 = df4periodalpha4."Nominal Interest Rate"


real_interest = df."Real Interest Rate"
real_interest_model2 = df4period."Real Interest Rate"
real_interest_model3 = dfpermanentshock."Real Interest Rate"
real_interest_model4 = df3temporaryshocks."Real Interest Rate"
real_interest_model5 = df4periodoutputpref."Real Interest Rate"
real_interest_model6 = df4periodphi95."Real Interest Rate"
real_interest_model7 = df4periodphi05."Real Interest Rate"
real_interest_model8 = df4periodalpha05."Real Interest Rate"
real_interest_model9 = df4periodalpha4."Real Interest Rate"





tick_quarters = Date.([Dates.Date(1958, 4), Dates.Date(1968, 4),
Dates.Date(1978, 4), Dates.Date(1988, 4), Dates.Date(1998, 4),
Dates.Date(2008, 4), Dates.Date(2014, 7), Dates.Date(2020, 7)])
DateTick = Dates.format.(tick_quarters, "yyyy-m")

period = 1:4:50
periodnew = 1:4:60


inf = plot(xaxis, inflation, label="Inflation's Response to Expectation Shock", xtick = false)
plot!(xticks = period, xtickfontsize = 5)
xlabel!("1st Period Shock and After (2 to 50)")
ylabel!("Inflation (%)")
savefig("inflation_expectationshock.pdf")

inf = plot(xaxis, inflation_model2, label="Inflation's Response to Expectation Shock", xtick = false)
plot!(xticks = period, xtickfontsize = 5)
xlabel!("4 Period Shock and After (5 to 50)")
ylabel!("Inflation (%)")
savefig("inflation_expectationshock4period.pdf")

inf = plot(xaxis, inflation_model3, label="Inflation", xtick = false)
plot!(xticks = period, xtickfontsize = 5)
xlabel!("Permanent Shock (1 to 50)")
ylabel!("Inflation (%)")
savefig("inflation_expectationshock50period.pdf")

inf = plot(xaxisnew, inflation_model4, label="Inflation", xtick = false)
plot!(xticks = periodnew, xtickfontsize = 5)
xlabel!("Series of 3 Temporary Shocks")
ylabel!("Inflation (%)")
savefig("inflation_seriesofexpectationshocks.pdf")


inf = plot(xaxis, inflation_model5, label="Inflation", xtick = false)
plot!(xticks = periodnew, xtickfontsize = 5)
xlabel!("4 Period Shock and After (5 to 50)")
ylabel!("Inflation (%)")
savefig("inflation_expectationshock4periodoutputpref.pdf")

inf = plot(xaxis, inflation_model6, label="Inflation", xtick = false)
plot!(xticks = period, xtickfontsize = 5)
xlabel!("4 Period Shock and After (5 to 50)")
ylabel!("Inflation (%)")
savefig("inflation_expectationshock4periodphi0.95.pdf")

inf = plot(xaxis, inflation_model7, label="Inflation", xtick = false)
plot!(xticks = period, xtickfontsize = 5)
xlabel!("4 Period Shock and After (5 to 50)")
ylabel!("Inflation (%)")
savefig("inflation_expectationshock4periodphi0.05.pdf")

inf = plot(xaxis, inflation_model8, label="Inflation", xtick = false)
plot!(xticks = period, xtickfontsize = 5)
xlabel!("4 Period Shock and After (5 to 50)")
ylabel!("Inflation (%)")
savefig("inflation_expectationshock4periodalpha0.05.pdf")

inf = plot(xaxis, inflation_model9, label="Inflation", xtick = false)
plot!(xticks = period, xtickfontsize = 5)
xlabel!("4 Period Shock and After (5 to 50)")
ylabel!("Inflation (%)")
savefig("inflation_expectationshock4periodalpha4.pdf")



o = plot(xaxis, output, label="Output's Response to Expectation Shock", xtick = false)
plot!(xticks = period, xtickfontsize = 5)
xlabel!("1st Period Shock and After (2 to 50)")
ylabel!("Output (50 is Long Run Equilibrium)")
savefig("output_expectationshock.pdf")

o = plot(xaxis, output_model2, label="Output's Response to Expectation Shock", xtick = false)
plot!(xticks = period, xtickfontsize = 5)
xlabel!("4 Period Shock and After (5 to 50)")
ylabel!("Output (50 is Long Run Equilibrium)")
savefig("output_expectationshock4period.pdf")

o = plot(xaxis, output_model3, label="Output", xtick = false)
plot!(xticks = period, xtickfontsize = 5)
xlabel!("Permanent Shock (1 to 50)")
ylabel!("Output (50 is Long Run Equilibrium)")
savefig("output_expectationshock50period.pdf")

o = plot(xaxisnew, output_model4, label="Output", xtick = false)
plot!(xticks = periodnew, xtickfontsize = 5)
xlabel!("Series of 3 Temporary Shocks")
ylabel!("Output (50 is Long Term Equilibrium)")
savefig("output_seriesofexpectationshocks.pdf")

o = plot(xaxis, output_model5, label="Output", xtick = false)
plot!(xticks = periodnew, xtickfontsize = 5)
xlabel!("4 Period Shock and After (5 to 50)")
ylabel!("Output")
savefig("output_expectationshock4periodoutputpref.pdf")

o = plot(xaxis, output_model6, label="Output", xtick = false)
plot!(xticks = period, xtickfontsize = 5)
xlabel!("4 Period Shock and After (5 to 50)")
ylabel!("Output")
savefig("output_expectationshock4periodphi0.95.pdf")

o = plot(xaxis, output_model7, label="Output", xtick = false)
plot!(xticks = period, xtickfontsize = 5)
xlabel!("4 Period Shock and After (5 to 50)")
ylabel!("Output")
savefig("output_expectationshock4periodphi0.05.pdf")

o = plot(xaxis, output_model8, label="Output", xtick = false)
plot!(xticks = period, xtickfontsize = 5)
xlabel!("4 Period Shock and After (5 to 50)")
ylabel!("Output")
savefig("output_expectationshock4periodalpha0.05.pdf")


o = plot(xaxis, output_model9, label="Output", xtick = false)
plot!(xticks = period, xtickfontsize = 5)
xlabel!("4 Period Shock and After (5 to 50)")
ylabel!("Output")
savefig("output_expectationshock4periodalpha4.pdf")


interest_rates = plot(xaxis, nominal_interest, label="Nominal Interest Rate", xtick = false)
plot!(xaxis, real_interest, label="Real Interest Rate", xtick = false)
plot!(xticks = period, xtickfontsize = 5)
xlabel!("1st Period Shock and After (2 to 50)")
ylabel!("Nominal/Real Interest Rates")
savefig("interestrates_expectationshock.pdf")



interest_rates = plot(xaxis, nominal_interest_model2, label="Nominal Interest Rate Response to Expectation Shock", xtick = false)
plot!(xaxis, real_interest_model2, label="Real Interest Rate Response to Expectation Shock", xtick = false)
plot!(xticks = period, xtickfontsize = 5)
xlabel!("4 Period Shock and After (5 to 50)")
ylabel!("Nominal/Real Interest Rates")
savefig("interestrates_expectationshock4period.pdf")


interest_rates = plot(xaxis, nominal_interest_model3, label="NIR", xtick = false)
plot!(xaxis, real_interest_model3, label="RIR", xtick = false)
plot!(xticks = period, xtickfontsize = 5)
xlabel!("Permanent Shock (1 to 50)")
ylabel!("Nominal/Real Interest Rates")
savefig("interestrates_expectationshock50period.pdf")

interest_rates = plot(xaxisnew, nominal_interest_model4, label="NIR", xtick = false)
plot!(xaxisnew, real_interest_model4, label="RIR", xtick = false)
plot!(xticks = periodnew, xtickfontsize = 5)
xlabel!("Series of 3 Temporary Shocks")
ylabel!("Nominal/Real Interest Rates")
savefig("interestrates_seriesofexpectationshocks.pdf")

interest_rates = plot(xaxis, nominal_interest_model5, label="Nominal Interest Rate Response to Expectation Shock", xtick = false)
plot!(xaxis, real_interest_model5, label="Real Interest Rate Response to Expectation Shock", xtick = false)
plot!(xticks = period, xtickfontsize = 5)
xlabel!("4 Period Shock and After (5 to 50)")
ylabel!("Nominal/Real Interest Rates")
savefig("interestrates_expectationshock4periodoutputpref.pdf")


interest_rates = plot(xaxis, nominal_interest_model6, label="Nominal Interest Rate Response to Expectation Shock", xtick = false)
plot!(xaxis, real_interest_model6, label="Real Interest Rate Response to Expectation Shock", xtick = false)
plot!(xticks = period, xtickfontsize = 5)
xlabel!("4 Period Shock and After (5 to 50)")
ylabel!("Nominal/Real Interest Rates")
savefig("interestrates_expectationshock4periodphi0.95.pdf")

interest_rates = plot(xaxis, nominal_interest_model7, label="Nominal Interest Rate Response to Expectation Shock", xtick = false)
plot!(xaxis, real_interest_model7, label="Real Interest Rate Response to Expectation Shock", xtick = false)
plot!(xticks = period, xtickfontsize = 5)
xlabel!("4 Period Shock and After (5 to 50)")
ylabel!("Nominal/Real Interest Rates")
savefig("interestrates_expectationshock4periodphi0.05.pdf")


interest_rates = plot(xaxis, nominal_interest_model8, label="Nominal Interest Rate Response to Expectation Shock", xtick = false)
plot!(xaxis, real_interest_model8, label="Real Interest Rate Response to Expectation Shock", xtick = false)
plot!(xticks = period, xtickfontsize = 5)
xlabel!("4 Period Shock and After (5 to 50)")
ylabel!("Nominal/Real Interest Rates")
savefig("interestrates_expectationshock4periodalpha0.05.pdf")


interest_rates = plot(xaxis, nominal_interest_model9, label="Nominal Interest Rate Response to Expectation Shock", xtick = false)
plot!(xaxis, real_interest_model9, label="Real Interest Rate Response to Expectation Shock", xtick = false)
plot!(xticks = period, xtickfontsize = 5)
xlabel!("4 Period Shock and After (5 to 50)")
ylabel!("Nominal/Real Interest Rates")
savefig("interestrates_expectationshock4periodalpha4.pdf")
