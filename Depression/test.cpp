#include <bits/stdc++.h>
using namespace std;

struct Process
{
    int id;
    int burstTime;
    int arrivalTime;
};

void calculateWaitingTime(Process processes[], int n, int waitingTime[])
{
    int remainingTime[n];
    for (int i = 0; i < n; i++)
        remainingTime[i] = processes[i].burstTime;

    int completed = 0, currentTime = 0, minRemaining = INT_MAX;
    int shortestIndex = 0, finishTime;
    bool isProcessSelected = false;

    while (completed != n)
    {
        for (int j = 0; j < n; j++)
        {
            if ((processes[j].arrivalTime <= currentTime) &&
                (remainingTime[j] < minRemaining) && remainingTime[j] > 0)
            {
                minRemaining = remainingTime[j];
                shortestIndex = j;
                isProcessSelected = true;
            }
        }

        if (!isProcessSelected)
        {
            currentTime++;
            continue;
        }

        remainingTime[shortestIndex]--;

        minRemaining = remainingTime[shortestIndex];
        if (minRemaining == 0)
            minRemaining = INT_MAX;

        if (remainingTime[shortestIndex] == 0)
        {
            completed++;
            isProcessSelected = false;
            finishTime = currentTime + 1;
            waitingTime[shortestIndex] = finishTime - processes[shortestIndex].burstTime - processes[shortestIndex].arrivalTime;
            if (waitingTime[shortestIndex] < 0)
                waitingTime[shortestIndex] = 0;
        }
        currentTime++;
    }
}

void calculateTurnaroundTime(Process processes[], int n, int waitingTime[], int turnaroundTime[])
{
    for (int i = 0; i < n; i++)
        turnaroundTime[i] = processes[i].burstTime + waitingTime[i];
}

void calculateAverageTime(Process processes[], int n)
{
    int waitingTime[n], turnaroundTime[n], totalWaitingTime = 0, totalTurnaroundTime = 0;
    calculateWaitingTime(processes, n, waitingTime);
    calculateTurnaroundTime(processes, n, waitingTime, turnaroundTime);
    cout << " P\t\tBT\t\tWT\t\tTAT\t\t\n";
    for (int i = 0; i < n; i++)
    {
        totalWaitingTime = totalWaitingTime + waitingTime[i];
        totalTurnaroundTime = totalTurnaroundTime + turnaroundTime[i];
        cout << " " << processes[i].id << "\t\t" << processes[i].burstTime << "\t\t " << waitingTime[i] << "\t\t " << turnaroundTime[i] << endl;
    }
    cout << "\nAverage waiting time = " << (float)totalWaitingTime / (float)n;
    cout << "\nAverage turnaround time = " << (float)totalTurnaroundTime / (float)n;
}

int main()
{
    Process processes[] = {{1, 6, 2}, {2, 2, 5}, {3, 8, 1}, {4, 3, 0}, {5, 4, 4}};
    int n = sizeof(processes) / sizeof(processes[0]);
    calculateAverageTime(processes, n);
    return 0;
}
