#include <iostream>
#include <vector>
#include <algorithm>

using namespace std;

// Структура узла графа
struct Node {
    void* data;
    vector<int> edges;  // список смежных вершин
};

// Структура для элемента стека
struct StackNode {
    int index;
    StackNode* next;
};

// Структура для стека на основе связного списка
struct Stack {
    StackNode* top;

    Stack() : top(nullptr) {}

    void push(int index) {
        StackNode* node = new StackNode();
        node->index = index;
        node->next = top;
        top = node;
    }

    int pop() {
        if (top == nullptr) {
            return -1;
        }
        StackNode* node = top;
        int index = node->index;
        top = top->next;
        delete node;
        return index;
    }

    bool isEmpty() {
        return top == nullptr;
    }

    ~Stack() {
        while (!isEmpty()) {
            pop();
        }
    }
};

// Глобальные переменные для хранения графа и результатов
int n;
vector<Node> nodes;
vector<bool> visited;
vector<int> ans;

// Функция для посещения узла
void visit(int v, Stack& stack) {
    Stack visitStack;
    visitStack.push(v);

    while (!visitStack.isEmpty()) {
        int u = visitStack.pop();

        if (!visited[u]) {
            visited[u] = true;
            stack.push(u);
        }

        for (int w : nodes[u].edges) {
            if (!visited[w]) {
                visitStack.push(w);
            }
        }
    }
}

// Топологическая сортировка без рекурсии
void topological_sort() {
    visited.assign(n, false);
    ans.clear();
    Stack stack;

    for (int i = 0; i < n; ++i) {
        if (!visited[i]) {
            visit(i, stack);
        }
    }

    while (!stack.isEmpty()) {
        ans.push_back(stack.pop());
    }

    reverse(ans.begin(), ans.end());
}

// Функция для печати результата сортировки
void print_result() {
    for (int i = 0; i < ans.size(); ++i) {
        cout << ans[i] + 1 << " ";  // +1, чтобы вернуть оригинальные номера вершин
    }
    cout << endl;
}

int main() {
    int m;
    cout << "Введите количество узлов и ребер: ";
    cin >> n >> m;

    nodes.resize(n);

    // Пример данных для узлов (дисциплины)
    string subjects[] = {"Math", "Physics", "Programming", "Algorithms", "Databases", "Operating Systems"};

    for (int i = 0; i < n; ++i) {
        nodes[i].data = static_cast<void*>(&subjects[i]);
    }

    cout << "Введите ребра графа (начало конец):" << endl;
    for (int i = 0; i < m; ++i) {
        int a, b;
        cin >> a >> b;
        nodes[a - 1].edges.push_back(b - 1);
    }

    topological_sort();
    print_result();

    return 0;
}
