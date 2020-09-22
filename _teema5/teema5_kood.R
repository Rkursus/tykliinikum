# --- Rakendustarkvara R
# --- V teema ----


# ----- Joonised paketiga ggplot2 ----

# Lae andmestik "students"
load(url("https://github.com/Rkursus/deltax/raw/master/data/students.RData"))

# vaatame andmestiku päist
head(students)

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


# Funktsioonid geom_boxplot() ja geom_jitter()
# Väärtuste hajuvusest ja jaotusest annavad aimu järgmised võimalused:
ggplot(students, aes(x = beer, y = weight)) + geom_boxplot()
ggplot(students, aes(x = beer, y = weight)) + geom_jitter()

# informatiivse joonise saame kahe eelneva kihi (boxploti ja punktide) kombineerimisel
ggplot(students, aes(x = beer, y = weight)) + 
  geom_boxplot() + 
  geom_jitter()


# Funktsioon stat_smooth()
# Saame lisada näiteks regressioonisirge iga grupi jaoks
ggplot(students, aes(x = height, y = weight, colour=gender)) + 
  geom_point() + 
  stat_smooth(method="lm", se=FALSE)
