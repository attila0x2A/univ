#include <thread>
#include <future>
#include <iostream>
#include <vector>
#include <random>
#include <string>

using namespace std;

const int MAX = 50;

vector<vector<double> > A, B;
vector<vector<double> > Res;
mutex Out;

void randM(vector<vector<double> > & M) {
    for (int i=0; i < M.size(); ++i) {
        for (int j=0; j < M[i].size(); ++j) {
            M[i][j] = rand() % MAX;
        }
    }
}

void printM(const vector<vector<double> > & M) {
    cout << "Size " << M.size() << 'x' << M[0].size() << '\n';
    for (int i=0; i < M.size(); ++i) {
        cout << M[i][0];
        for (int j=1; j < M[i].size(); ++j) {
            cout << ' ' << M[i][j];
        }
        cout << '\n';
    }
}

void calc(int i, int j) {
    double res = 0;
    for (int k = 0; k < A[i].size(); ++k) {
        res += A[i][k] * B[k][j];
    }

    Out.lock();
    Res[i][j] = res;
    cout << "Calculated " << i << ' ' << j << ": " << res << endl;
    Out.unlock();
}

int main(int argc, char *argv[]) {
    int n, m, k;
    if (argc == 1) {
        cin >> n >> m >> k;
        A.assign(n, vector<double>(m));
        B.assign(m, vector<double>(k));

        for (int i=0; i < n; ++i) {
            for (int j=0; j < m; ++j) {
                cin >> A[i][j];
            }
        }

        for (int i=0; i < m; ++i) {
            for (int j=0; j < k; ++j) {
                cin >> B[i][j];
            }
        }
    } else if ((string)argv[1] == "-a") {
        n = random() % MAX;
        m = random() % MAX;
        k = random() % MAX;
        A.assign(n, vector<double>(m));
        B.assign(m, vector<double>(k));
        randM(A);
        randM(B);

        cout << "Using the following parameters:\n";
        cout << "n: " << n << '\n';
        cout << "m: " << m << '\n';
        cout << "k: " << k << '\n';
        cout << "A:\n";
        printM(A);

        cout << "B:\n";
        printM(B);
        cout << endl;
    } else {
        cout << "Usage: \n";
        cout << "./main [-a]\n";
        cout << "-a\t--\tGenerate automatically\n";
        return 1;
    }
    Res.assign(n, vector<double>(k, 0));

    cout << "Starting threads" << endl;
    vector<vector<thread*> > tds(n, vector<thread*>(k));
    for (int i=0; i < n; ++i) {
        for (int j=0; j < k; ++j) {
            tds[i][j] = new thread(calc, i, j);
        }
    }

    for (int i=0; i < n; ++i) {
        for (int j=0; j < k; ++j) {
            tds[i][j] -> join();
        }
    }

    for (int i=0; i < n; ++i) {
        for (int j=0; j < k; ++j) {
            delete tds[i][j];
        }
    }

    cout << "Finished calculation!\n";
    cout << "Resulting matrix:\n";
    printM(Res);
    cout << endl;
    return 0;
}
