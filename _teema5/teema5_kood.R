# --- Rakendustarkvara R
# --- V teema ----


# ----- 1. Joonised paketiga ggplot2 ----

# Lae andmestik "students"
load(url("https://github.com/Rkursus/deltax/raw/master/data/students.RData"))

# vaatame andmestiku päist
head(students)

# Paigalda ja lae pakett ggplot2
install.packages('ggplot2')
library(ggplot2)

# Graafikute grammatika (Wilkinson) on kontseptsioon, mille kohaselt graafiku 
#  ehitamisel ei tuleks lähtuda mitte graafiku tüübist, vaid andmetest. 
#  Iga joonis koosneb järgnevatest osadest:
#  - andmed (inimeste palk ja sugu)
#  - skaalad (kas esitada palk värviskaalal või x-teljel? kas palga esitamiseks sobib nt log-skaala?)
#  - statistikud (kas palga puhul kujutada keskmist või summat)
#  - geomeetrilised kujundid (kas keskmine peaks olema märgitud tulba kõrgusega või hoopis punktikesega)
#  - koordinaadid (äkki sobib polaarkoordinaadistik?)
#  - tahud (joonis jagatud erinevateks alamjoonisteks)
#  - üldkujundus (font jms)

# Andmete ja skaalade seadistamine käib umbes järgnevalt
# ggplot(andmed, aes(x = tunnus1, y = tunnus2))

# Proovime!

# 2.1 Hajuvusdiagramm ----
# Hajuvusdiagrammi (scatterplot) tegemiseks
ggplot(students, aes(x = height, y = weight)) + 
  geom_point()


# Värvi saame lisada järgmiselt: colour = tunnuse_nimi
ggplot(students, aes(x = height, y = weight, colour = gender)) + 
  geom_point()

# Uurime erinevaid jooniste võimalusi:

# Funktsioonid facet_grid() ja facet_wrap()
# Näiteks tunnuse 'beer' põhjal saame oma joonise jagada alamjoonisteks (tahkudeks) järgnevalt
ggplot(students, aes(x = height, y = weight, colour = gender)) + 
  geom_point() + 
  facet_wrap(~ beer)


# Histogramm ja jaotused
# geom_histogram()
ggplot(students, aes(x = weight)) + 
  geom_histogram()

# Saame histogrammi tulpasid värvida soo järgi
ggplot(students, aes(x = weight, fill=gender)) + 
  geom_histogram()

# ... Või jagada histogramm tahkudeks soo järgi, üksteise alla
ggplot(students, aes(x = weight, fill=gender)) + 
  geom_histogram() + 
  facet_wrap(~ gender, ncol=1)

# Mitteparameetriline tiheduse hinnang
ggplot(students, aes(x = weight, fill=gender)) + 
  geom_density(alpha=0.5)


### 2.1.2 Ülesanded ----

# Joonista hajuvusdiagramm tudengite andmestikust tunnuste SVR (süstoolne vererõhk) ja DVR (diastoolne vererõhk) vahel?


# Lisa joonisele sugu (gender); katseta erinevaid variante (värv, kuju jne).


# Kujuta joonisel mingil moel ka kaalu (weigth).




# 2.2 Joonise tahkudeks jagamine ----

# käskude facet_grid() või facet_wrap()
ggplot(students, aes(x = height, y = weight, colour = gender)) + 
  geom_point() + 
  facet_wrap(~ beer)

ggplot(students, aes(x = height, y = weight, colour = gender)) + 
  geom_point() + 
  facet_grid(beer ~ gender)

# 2.3 Tulpdiagramm ja histogramm ----

# Graafiku teljed võivad olla seotud ka diskreetse tunnusega
ggplot(data = students, aes(x = beer)) + geom_bar()

# Ühe tulba sees võivad olla erinevad värvid
ggplot(data = students, aes(x = beer)) + geom_bar(aes(fill = Poverty_factor))

# Kui on soov esitada andmetes esinevate sageduste asemel osakaalud, siis lisa 'position = "fill"'
ggplot(data = students, aes(x = beer)) +
  geom_bar(aes(fill = Poverty_factor), position = "fill") +
  ylab("osakaal")

# Tulbad horisontaalselt
ggplot(data = students, aes(x = beer)) + geom_bar() + coord_flip()

# Kui toorandmete asemel on juba valmis sagedustabel
sagedustabel <- as.data.frame(table(students$beer))
ggplot(sagedustabel, aes(x = Var1, y = Freq)) + geom_bar(stat = "identity")



# Pideva tunnuse uurimiseks on mõistlik kasutada histogrammi
ggplot(students, aes(x = weight)) + 
  geom_histogram()

# Saame histogrammi tulpasid värvida soo järgi
ggplot(students, aes(x = weight, fill=gender)) + 
  geom_histogram()

# Või jagada histogramm tahkudeks soo järgi, üksteise alla
ggplot(students, aes(x = weight, fill=gender)) + 
  geom_histogram() + 
  facet_wrap(~ gender, ncol=1)

# Mitteparameetriline tiheduse hinnang
ggplot(students, aes(x = weight, fill = gender)) + 
  geom_density(alpha=0.5)

# 2.4 Karpdiagramm ----

# Funktsioonid geom_boxplot() ja geom_jitter()
# Väärtuste hajuvusest ja jaotusest annavad aimu järgmised võimalused:
ggplot(students, aes(x = beer, y = weight)) + geom_boxplot()
ggplot(students, aes(x = beer, y = weight)) + geom_jitter()

ggplot(students, aes(x = height, y = weight, colour = gender)) + 
  geom_point() + 
  facet_wrap(~ beer)

# informatiivse joonise saame kahe eelneva kihi (boxploti ja punktide) kombineerimisel
ggplot(students, aes(x = beer, y = weight)) + 
  geom_boxplot() + 
  geom_jitter()

# 2.5 Seose näitamine joonisel ----

# Funktsioon stat_smooth()
# Saame lisada näiteks regressioonisirge iga grupi jaoks
ggplot(students, aes(x = height, y = weight, colour=gender)) + 
  geom_point() + 
  stat_smooth(method="lm", se=FALSE)


# 2.5.1 Ülesanded

# Joonista tudengite vanuse (tunnus age) histogramm.



# Uuri tunnuse height jaotust erinevates tunnuse beer kategooriates, kasutades karpdiagrammi.




# Tee hajuvusdiagramm vererõhunäitudele (DVR ja `SVR) ja lisa sinna regressioonsirge. Proovi lisada regressioonsirge kummagi soo jaoks eraldi.






