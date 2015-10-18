#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include<ctype.h>
#include<math.h>
#include"header.h"

#define TABLE_SIZE	256

symtab * hash_table[TABLE_SIZE];
int num_id;
extern int linenumber;

int HASH(char * str){
	int idx=0;
	while(*str){
		idx = idx << 1;
		idx+=*str;
		str++;
	}	
	return (idx & (TABLE_SIZE-1));
}

/*returns the symbol table entry if found else NULL*/

symtab * lookup(char *name){
	int hash_key;
	symtab* symptr;
	if(!name)
		return NULL;
	hash_key=HASH(name);
	symptr=hash_table[hash_key];

	while(symptr){
		if(!(strcmp(name,symptr->lexeme)))
			return symptr;
		symptr=symptr->front;
	}
	return NULL;
}


void insertID(char *name){
	int hash_key;
	symtab* ptr;
	symtab* symptr=(symtab*)malloc(sizeof(symtab));	
	
	hash_key=HASH(name);
	ptr=hash_table[hash_key];
	
	if(ptr==NULL){
		/*first entry for this hash_key*/
		hash_table[hash_key]=symptr;
		symptr->front=NULL;
		symptr->back=symptr;
	}
	else{
		symptr->front=ptr;
		ptr->back=symptr;
		symptr->back=symptr;
		hash_table[hash_key]=symptr;	
	}

        num_id++;	
	strcpy(symptr->lexeme,name);
	symptr->line=linenumber;
	symptr->counter=1;
}

void printSym(symtab* ptr) 
{
	    printf(" Name = %s \n", ptr->lexeme);
	    printf(" References = %d \n", ptr->counter);
}

int cmp(const void *a, const void *b)
{
    symtab* c = a;
    symtab* d = b;

//    printf("%s %s\n", c->lexeme, d->lexeme);
    return strcmp(c->lexeme, d->lexeme);
}

void printSymTab()
{
    int i, j;
    symtab *new_table;
    printf("----- Symbol Table ---------\n");

    new_table = (symtab*) malloc(num_id*sizeof(symtab));

    j=0;
    for (i=0; i<TABLE_SIZE; i++)
    {
        symtab* symptr;
	symptr = hash_table[i];
	while (symptr != NULL)
	{
            /* Add to new table */
            new_table[j++]=*symptr;
            symptr=symptr->front;
	}
    }
    /* Sort */
    qsort(new_table, num_id, sizeof(symtab), cmp);

    /* Print the new table */
    for(i=0; i<num_id; i++)
    {
        printf("====>  index = %d \n", i);
        printSym(&new_table[i]);
    }
}
