## Screening for corrupted reads

Tool [Seqkit sana](https://bioinf.shenwei.me/seqkit/usage/#sana)

Example:
```
seqkit sana inplanta-3KO-022-R1.fastq.gz -o inplanta-3KO-022-R1.rescued.fastq.gz
```

| Corrupted files              | Pass records | Discarded lines |
|------------------------------|--------------|-----------------|
| inplanta-3KO-020-R2.fastq.gz | 183114948    | 107355330       |
| inplanta-3KO-022-R1.fastq.gz | 168329945    | 136665612       |
| inplanta-3KO-023-R2.fastq.gz | 276989110    | 89199061        |

Example output
* Reads are merged with quality scores
* Length of the reads is shorter then the quality score
```
[INFO] File: inplanta-3KO-020-R2.fastq.gz       Discarded line: Invalid line states!    840424447:       NCANGATCTCCCANNAGGAGTACCTCAACGCCCCCGGGGAGACCTTCTCCGTCACGCTCACCGTCCCCGGCACCTACGGCTTCTACTGCGAGCCCCACGCCGGAGCCGGCATGGACGGCCAGGTCCTG#</#<<B/BF/FF###################################################################################################################FFFFW2ANX:8:2FFFFFW2AN316:21268:101294 2:N:0:
[INFO] File: inplanta-3KO-020-R2.fastq.gz       Discarded line: Invalid line states!    840424448:       NACNGCAGTCTCCNNGGCCTCCAGGGTTACAGGGTGATCAGATCCAGCGCCATGATCCTCGGGGACGGCCTGTACAACTTCGCAAAGGTGCCCGTACGCACGAGCGTCCCCCACGCGGCCATGCTCTG################################################################################################################################FFFFW2ANX:8:2FFFFFW2AN316:21298:101317 2:N:0:
[INFO] File: inplanta-3KO-020-R2.fastq.gz       Discarded line: Invalid line states!    840424449:       NAANGAATGCATNNNNTGNTACTACTACAAGATCTAAATCTTATTTTCGAAATAAGACAGTGTGGACACATTTGAACAGTATTTCCTCTAGAACTTTCAACCGAAAATATGTATCTTTGCATGTACTG#<<#<<<BFFFF####<B#<<<FFFFFFFFFFFFFFFBBFBFF<FFFFFFFFFFFFFBFFBFFFFFFFFBFFFFFFFF<<F//FF<FF<F//FFFFBBBB/BBF</B<B</<F/7<FBFBFF/F<###FFFFW2ANX:8:2FFFFFW2AN316:21260:101327 2:N:0:
[INFO] File: inplanta-3KO-020-R2.fastq.gz       Discarded line: gzip: invalid checksum  840119786:       NTCNGCGGTATGGNGCCTCGCGCAGTGCCGCGGCGACGTCCCGCGCCAGGACTGCTCGCTCTGCCTCGCCGCGGCGGCCCAGGAGGGCGCGGCGTCCTGCCGCGGCAGCCCGGACGGGCGGGGCCCTG#<<#/<BF/<FFF#<<B<FFFBFFFFFFFBB<FBBFF/<BBF<F/F/BFF/BBBF/<F<<B7F<///<BB<F<B###################################################
....
[INFO] File: inplanta-3KO-022-R2.fastq.gz       Discarded line: Sequence (125) and quality (127) length mismatch       145917522:       @HISEQ:165:C9WE2ANXX:3:12:4579:42616 2:N:0:
[INFO] File: inplanta-3KO-022-R2.fastq.gz       Discarded line: Sequence (125) and quality (127) length mismatch       145917523:       GTTCTCCCCAAGCACCTCGACGAGAAGGTCGCGGCCCTCCACTTGGGCAAGCTCGGCGCCAGGCTGACCAAGCTCACCAAGTCCCAGTCTGACTACATTAGCATCCCAGTTGAGGGTCCGTACAA
[INFO] File: inplanta-3KO-022-R2.fastq.gz       Discarded line: Sequence (125) and quality (127) length mismatch       145917524:       +
[INFO] File: inplanta-3KO-022-R2.fastq.gz       Discarded line: Sequence (125) and quality (127) length mismatch       145917525:       BBBBBFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
```
