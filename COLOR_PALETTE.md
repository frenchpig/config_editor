# 🥝 Frutiger Aero: Descripción Exhaustiva y Lineamientos de Interfaz

**Frutiger Aero** (FA) es un estilo de diseño digital que floreció a finales de la década de 2000 y principios de la de 2010. Se caracteriza por un **optimismo tecnológico** y una estética que celebra la riqueza visual, la limpieza y la conexión orgánica/natural con la tecnología.

---

## ✨ Características Fundamentales del Estilo

| Característica | Descripción Clave | Intención del Diseño |
| :--- | :--- | :--- |
| **Glassmorfismo (Vidrio Esmerilado)** | Uso extenso de transparencia, desenfoque y reflejos para simular cristal pulido (como Windows Aero). | Crear profundidad, enfocar el contenido y dar una sensación de ligereza. |
| **Materiales Orgánicos** | Texturas que evocan la **naturaleza, el agua, burbujas**, césped, cielos azules y orbes brillantes. | Conectar la tecnología con el mundo real de manera sintética y vibrante. |
| **Cromado y Brillo** | Acabados de **alto brillo**, efectos de *lens flare* (destellos) y bordes **biselados** (3D suave) en elementos. | Transmitir una sensación "premium", futurismo y calidad táctil. |
| **Paleta de Colores** | Colores **saturados y vibrantes**: azules acuáticos, verde lima, naranja soleado y blanco/gris limpio. | Generar alegría, energía y optimismo en el usuario. |
| **Tipografía Limpia** | Predominio de fuentes **sans-serif humanistas** altamente legibles (ej. Segoe UI, Frutiger). | Mantener la legibilidad mientras se infunde calidez y accesibilidad. |

---

## 🖥️ Lineamientos de Interfaz (UI) al Estilo Frutiger Aero

Una interfaz diseñada en este estilo debe buscar la riqueza de texturas y el efecto de profundidad por encima de la simplicidad plana (flat design).

### 1. Entorno y Ventanas

* **Fondos:** Imágenes de alta resolución de **cielos despejados, paisajes verdes o composiciones abstractas de burbujas/agua**. Siempre vibrantes.
* **Ventanas (Aero Glass):**
    * Marcos de ventana **semitransparentes** ($\alpha \approx 0.7$ a $0.9$).
    * Aplicación de **desenfoque gaussiano** al contenido detrás del marco (Glassmorfismo).
    * Esquinas **redondeadas** con un radio moderado.
    * Inclusión de un **reflejo de luz sutil** en la parte superior del marco, simulando el brillo del cristal.

### 2. Controles e Iconografía

* **Botones:**
    * Efecto **biselado** para dar una apariencia 3D *inflada* y táctil.
    * Uso de **degradados** sutiles de claro a oscuro (arriba a abajo).
    * Estado activo/hover con **brillo** o *lens flare*.
* **Iconografía:**
    * Debe ser **detallada**, a menudo en 3D o 2.5D.
    * Texturas de **cromo, plástico pulido** y múltiples reflejos.
    * No son iconos planos; tienen profundidad y volumen.

### 3. Elementos Adicionales

* **Widgets/Tarjetas:** Deben flotar por encima del fondo, usando un **drop shadow** (sombra proyectada) suave y con sus propios efectos de Glassmorfismo o texturas (p. ej., burbujas).
* **Barras de Progreso:** A menudo parecen **tubos de gel o líquido** brillante, utilizando colores saturados.
* **Animaciones:** Fluidas y suaves. Las transiciones deben sugerir movimiento acuático, como ondas o el desplazamiento de un objeto flotante.

## Colores del Sistema por Aplicación

Esta sección documenta los colores específicos utilizados en cada aplicación del sistema para facilitar la generación de nuevas visuales consistentes.

### Waybar

**Formato**: CSS con `rgba()` para transparencias

| Elemento | Color | Formato | Uso |
|----------|-------|---------|-----|
| **Fondo principal** | `rgba(173, 216, 230, 0.85)` a `rgba(175, 238, 238, 0.85)` | Gradiente lineal 135deg | Fondo de la barra (light blue → light green → pale turquoise) |
| **Texto principal** | `rgba(30, 50, 70, 0.95)` | `#1E3246` con opacidad | Texto de módulos |
| **Borde inferior** | `rgba(255, 255, 255, 0.3)` | Blanco semitransparente | Separador de la barra |
| **Workspace normal** | `rgba(255, 255, 255, 0.3)` | Blanco semitransparente | Botones de workspace inactivos |
| **Workspace hover** | `rgba(255, 255, 255, 0.45)` | Blanco más opaco | Estado hover de workspaces |
| **Workspace activo** | Gradiente: `rgba(255, 255, 255, 0.85)` → `rgba(173, 216, 230, 0.7)` → `rgba(200, 255, 255, 0.75)` | Gradiente 135deg | Workspace actual |
| **Borde workspace activo** | `rgba(255, 255, 255, 0.9)` | Blanco casi opaco | Borde destacado |
| **Workspace urgente** | `rgba(255, 200, 200, 0.4)` | Rosa pastel | Workspace con ventana urgente |
| **Texto urgente** | `rgba(180, 50, 50, 1)` | `#B43232` | Texto de workspace urgente |
| **Clock fondo** | `rgba(255, 255, 255, 0.4)` → `rgba(200, 255, 255, 0.35)` | Gradiente 135deg | Fondo del reloj |
| **Tooltip fondo** | `rgba(255, 255, 255, 0.95)` → `rgba(230, 255, 255, 0.9)` | Gradiente 135deg | Fondo de tooltips |
| **Tooltip texto** | `rgba(80, 100, 120, 1)` | `#507878` | Texto de tooltips |
| **Sombra texto** | `rgba(255, 255, 255, 0.8-1.0)` | Blanco semitransparente | Efecto de profundidad en texto |
| **Sombra box** | `rgba(173, 216, 230, 0.4)` | Light blue semitransparente | Sombra de elementos activos |

**Conversión RGB a Hex**:
- `rgba(173, 216, 230, 0.85)` = `#ADD8E6` con opacidad 0.85
- `rgba(144, 238, 144, 0.75)` = `#90EE90` con opacidad 0.75
- `rgba(175, 238, 238, 0.85)` = `#AFEEEE` con opacidad 0.85
- `rgba(30, 50, 70, 0.95)` = `#1E3246` con opacidad 0.95

### Mako

**Formato**: `#RRGGBBAA` (hex con alpha en los últimos 2 dígitos)

| Elemento | Color | Hex | Descripción |
|----------|-------|-----|-------------|
| **Fondo normal** | `#AFEEEEE9` | Pale turquoise con alpha E9 (233/255 ≈ 0.91) | Notificaciones normales |
| **Texto normal** | `#1E3246` | Azul oscuro | Texto principal |
| **Borde normal** | `#FFFFFF4D` | Blanco con alpha 4D (77/255 ≈ 0.30) | Borde sutil |
| **Urgencia baja - fondo** | `#ADD8E6D9` | Light blue con alpha D9 (217/255 ≈ 0.85) | Notificaciones informativas |
| **Urgencia baja - borde** | `#ADD8E6D9` | Mismo que fondo | Borde de urgencia baja |
| **Urgencia normal - fondo** | `#AFEEEEE9` | Pale turquoise | Notificaciones normales |
| **Urgencia normal - borde** | `#90EE90BF` | Light green con alpha BF (191/255 ≈ 0.75) | Borde de urgencia normal |
| **Urgencia crítica - fondo** | `#FFC8C866` | Rosa pastel con alpha 66 (102/255 ≈ 0.40) | Notificaciones críticas |
| **Urgencia crítica - borde** | `#FFC8C866` | Mismo que fondo, tamaño 2px | Borde destacado |
| **Texto crítico** | `#B43232` | Rojo oscuro | Texto de urgencia crítica |
| **Progreso** | `#ADD8E6` | Light blue sólido | Barra de progreso |

**Conversión de opacidad a hex**:
- 0.91 → E9 (233 decimal)
- 0.85 → D9 (217 decimal)
- 0.75 → BF (191 decimal)
- 0.40 → 66 (102 decimal)
- 0.30 → 4D (77 decimal)

### Hyprland

**Formato**: `rgba(RRGGBBAA)` (hex sin #, alpha al final)

| Elemento | Color | Formato | Descripción |
|----------|-------|---------|-------------|
| **Borde activo** | `rgba(33ccffee) rgba(00ff99ee) 45deg` | Gradiente de cian a verde | Borde de ventana activa con gradiente |
| **Borde inactivo** | `rgba(595959aa)` | Gris semitransparente | Borde de ventanas inactivas |
| **Sombra** | `rgba(1a1a1aee)` | Negro casi opaco | Sombra de ventanas |

**Conversión**:
- `33ccff` = `#33CCFF` (cyan)
- `00ff99` = `#00FF99` (verde brillante)
- `595959` = `#595959` (gris medio)
- `1a1a1a` = `#1A1A1A` (negro)
- `ee` = alpha 238/255 ≈ 0.93
- `aa` = alpha 170/255 ≈ 0.67

### Kitty

**Formato**: Hex estándar `#RRGGBB`

| Elemento | Color | Hex | Uso |
|----------|-------|-----|-----|
| **Background** | `#2A4A52` | Verde-azul oscuro | Fondo del terminal |
| **Foreground** | `#E0F7FA` | Casi blanco | Texto principal |
| **Cursor** | `#E0F7FA` | Casi blanco | Cursor visible |
| **Cursor text** | `#2A4A52` | Verde-azul oscuro | Texto bajo cursor |
| **URL** | `#4ECDC4` | Turquesa | Enlaces |
| **Selection foreground** | `#E0F7FA` | Casi blanco | Texto seleccionado |
| **Selection background** | `#458588` | Teal medio | Fondo seleccionado |
| **Pestaña activa - foreground** | `#E0F7FA` | Casi blanco | Texto de pestaña activa |
| **Pestaña activa - background** | `#458588` | Teal medio | Fondo de pestaña activa |
| **Pestaña inactiva - foreground** | `#B0D4E1` | Azul claro | Texto de pestaña inactiva |
| **Pestaña inactiva - background** | `#3A5A62` | Verde-azul medio | Fondo de pestaña inactiva |

**Paleta completa de 16 colores**: Ver sección "Paleta de 16 Colores" arriba.

### Wleave

**Formato**: CSS con `rgba()` para transparencias

| Elemento | Color | Formato | Uso |
|----------|-------|---------|-----|
| **Fondo ventana** | `rgba(20, 20, 20, 0.85)` | Negro con opacidad 0.85 | Fondo del menú de logout |
| **Botón hover** | `rgba(255, 255, 255, 0.1)` | Blanco semitransparente | Estado hover de botones |
| **Botón active** | `rgba(255, 255, 255, 0.2)` | Blanco más opaco | Estado presionado |

**Nota**: Wleave usa variables CSS (`var(--view-fg-color)`, `var(--accent-color)`) que deben definirse en el tema del sistema.

## Guía para Generar Nuevas Visuales

### Paso 1: Identificar el Tipo de Aplicación

1. **CSS/GTK CSS** (Waybar, Wleave): Usar `rgba(R, G, B, alpha)` con valores 0.0-1.0
2. **Mako/Dunst**: Usar formato `#RRGGBBAA` (8 dígitos hex)
3. **Hyprland**: Usar `rgba(RRGGBBAA)` sin #, alpha al final
4. **Terminales** (Kitty, Alacritty): Usar `#RRGGBB` estándar

### Paso 2: Aplicar la Paleta Base

- **Fondo principal**: `#2A4A52` (o variante pastel para elementos glass)
- **Texto principal**: `#E0F7FA` (o `#1E3246` para fondos claros)
- **Elementos activos**: `#458588` o variantes pastel
- **Elementos hover**: Versión más clara/opaca del color base

### Paso 3: Aplicar Estilo Frutiger Aero

- **Transparencias**: 0.85-0.95 para fondos principales, 0.3-0.5 para elementos glass
- **Gradientes**: Usar gradientes lineales 135deg con colores pastel relacionados
- **Bordes**: Blancos semitransparentes (`rgba(255, 255, 255, 0.3-0.9)`)
- **Sombras**: Suaves con colores relacionados (light blue, turquoise)
- **Text-shadow**: Blanco semitransparente para legibilidad sobre glass

### Paso 4: Mantener Consistencia

- Revisar colores en aplicaciones relacionadas (Waybar ↔ Mako)
- Usar la misma paleta de 16 colores para terminales
- Aplicar la misma lógica de urgencia/estado (baja=azul, normal=verde/turquoise, crítica=rojo)
- Mantener ratios de transparencia similares entre elementos relacionados

### Paso 5: Conversión de Formatos

**De Hex a RGBA (CSS)**:
```css
/* #2A4A52 con opacidad 0.85 */
background: rgba(42, 74, 82, 0.85);
```

**De Hex a RRGGBBAA (Mako)**:
```
/* #2A4A52 con opacidad 0.85 (217 decimal = D9 hex) */
→ #2A4A52D9
```

**De Hex a rgba() (Hyprland)**:
```
/* #33CCFF con opacidad 0.93 (238 decimal = EE hex) */
→ rgba(33ccffee)
```

# 🥝 Frutiger Aero: Descripción Exhaustiva y Lineamientos de Interfaz

**Frutiger Aero** (FA) es un estilo de diseño digital que floreció a finales de la década de 2000 y principios de la de 2010. Se caracteriza por un **optimismo tecnológico** y una estética que celebra la riqueza visual, la limpieza y la conexión orgánica/natural con la tecnología.

---

## ✨ Características Fundamentales del Estilo

| Característica | Descripción Clave | Intención del Diseño |
| :--- | :--- | :--- |
| **Glassmorfismo (Vidrio Esmerilado)** | Uso extenso de transparencia, desenfoque y reflejos para simular cristal pulido (como Windows Aero). | Crear profundidad, enfocar el contenido y dar una sensación de ligereza. |
| **Materiales Orgánicos** | Texturas que evocan la **naturaleza, el agua, burbujas**, césped, cielos azules y orbes brillantes. | Conectar la tecnología con el mundo real de manera sintética y vibrante. |
| **Cromado y Brillo** | Acabados de **alto brillo**, efectos de *lens flare* (destellos) y bordes **biselados** (3D suave) en elementos. | Transmitir una sensación "premium", futurismo y calidad táctil. |
| **Paleta de Colores** | Colores **saturados y vibrantes**: azules acuáticos, verde lima, naranja soleado y blanco/gris limpio. | Generar alegría, energía y optimismo en el usuario. |
| **Tipografía Limpia** | Predominio de fuentes **sans-serif humanistas** altamente legibles (ej. Segoe UI, Frutiger). | Mantener la legibilidad mientras se infunde calidez y accesibilidad. |

---

## 🖥️ Lineamientos de Interfaz (UI) al Estilo Frutiger Aero

Una interfaz diseñada en este estilo debe buscar la riqueza de texturas y el efecto de profundidad por encima de la simplicidad plana (flat design).

### 1. Entorno y Ventanas

* **Fondos:** Imágenes de alta resolución de **cielos despejados, paisajes verdes o composiciones abstractas de burbujas/agua**. Siempre vibrantes.
* **Ventanas (Aero Glass):**
    * Marcos de ventana **semitransparentes** ($\alpha \approx 0.7$ a $0.9$).
    * Aplicación de **desenfoque gaussiano** al contenido detrás del marco (Glassmorfismo).
    * Esquinas **redondeadas** con un radio moderado.
    * Inclusión de un **reflejo de luz sutil** en la parte superior del marco, simulando el brillo del cristal.

### 2. Controles e Iconografía

* **Botones:**
    * Efecto **biselado** para dar una apariencia 3D *inflada* y táctil.
    * Uso de **degradados** sutiles de claro a oscuro (arriba a abajo).
    * Estado activo/hover con **brillo** o *lens flare*.
* **Iconografía:**
    * Debe ser **detallada**, a menudo en 3D o 2.5D.
    * Texturas de **cromo, plástico pulido** y múltiples reflejos.
    * No son iconos planos; tienen profundidad y volumen.

### 3. Elementos Adicionales

* **Widgets/Tarjetas:** Deben flotar por encima del fondo, usando un **drop shadow** (sombra proyectada) suave y con sus propios efectos de Glassmorfismo o texturas (p. ej., burbujas).
* **Barras de Progreso:** A menudo parecen **tubos de gel o líquido** brillante, utilizando colores saturados.
* **Animaciones:** Fluidas y suaves. Las transiciones deben sugerir movimiento acuático, como ondas o el desplazamiento de un objeto flotante.


