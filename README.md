# JaccardSimilarity
Calculate the Jaccard Similarity Coefficient between two sets of terms based on their ancestors in an OBO ontology.

USAGE

```shell
./jaccard.sh <Set1> <Set2> <OBOfile> [max_ancestry_level]
```
- ```max_ancestry_level``` is an optional parameter to reduce the number of ancestors used. It defines the maximum number of edges between the terms and the ancestors. 

Examples:

```shell
./jaccard.sh "[21034, 2694, 56829, 10564, 36313, 11795]" "[21034, 2694, 29315, 331, 10564, 3234, 53368, 19625]" decs.obo 
./jaccard.sh "[21034, 2694, 56829, 10564, 36313, 11795]" "[21034, 2694, 29315, 331, 10564, 3234, 53368, 19625]" decs.obo 10
```

```shell
./jaccard.sh "2841,1324" "1324,1323" doid.obo 
./jaccard.sh "2841,1324" "1324,1323" doid.obo 2
```

