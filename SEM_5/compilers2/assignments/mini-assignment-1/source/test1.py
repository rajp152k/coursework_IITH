n=10
def fib(i,ans):
    if(i==n) :
        return ans
    else:
        i+=1
        return fib(i,ans*i)

print(fib(0,1))
