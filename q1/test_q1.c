#include <stdio.h>

struct Node {
    int val;
    struct Node *left;
    struct Node *right;
};

extern struct Node* insert(struct Node* root, int val);
extern struct Node* get(struct Node* root, int val);
extern int getAtMost(int target, struct Node* root);

int main() {
    struct Node* root = NULL;
    int vals[] = {15, 10, 20, 8, 12, 17, 25};
    for(int i=0; i<7; i++) root = insert(root, vals[i]);

    // Test getAtMost
    printf("At most 11: %d (Expected 10)\n", getAtMost(11, root));
    printf("At most 15: %d (Expected 15)\n", getAtMost(15, root));
    printf("At most 5: %d (Expected -1)\n", getAtMost(5, root));
    
    return 0;
}