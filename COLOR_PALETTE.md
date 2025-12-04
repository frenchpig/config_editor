# Paleta de Colores Frutiger Aero Dark

Guía para aplicar la paleta de colores a nuevas aplicaciones del sistema.

## Paleta Base

### Colores Principales

| Propósito | Color | Hex | Descripción |
|-----------|-------|-----|-------------|
| **Background** | Fondo principal | `#2A4A52` | Verde-azul oscuro, base del tema |
| **Foreground** | Texto principal | `#E0F7FA` | Casi blanco, texto de alto contraste |
| **Selection Background** | Fondo seleccionado | `#458588` | Teal medio, para elementos activos |
| **Selection Foreground** | Texto seleccionado | `#E0F7FA` | Mismo que foreground |
| **Cursor** | Color del cursor | `#E0F7FA` | Cursor visible |
| **Cursor Text** | Texto bajo cursor | `#2A4A52` | Contraste inverso |
| **URL** | Enlaces | `#4ECDC4` | Turquesa claro para destacar |

### Paleta de 16 Colores

#### Colores Básicos (0-7)

| Color | Hex | Uso Recomendado |
|-------|-----|-----------------|
| **color0** (Negro) | `#3A5A62` | Fondos alternativos, elementos inactivos |
| **color1** (Rojo) | `#E67E80` | Errores, advertencias importantes |
| **color2** (Verde) | `#7ED321` | Éxito, confirmación, estados positivos |
| **color3** (Amarillo) | `#F5B041` | Advertencias, información importante |
| **color4** (Azul) | `#5DA8D1` | Información, enlaces, acciones primarias |
| **color5** (Magenta) | `#A78BFA` | Destacados, elementos especiales |
| **color6** (Cian) | `#4ECDC4` | Información secundaria, URLs |
| **color7** (Blanco) | `#E0F7FA` | Texto principal, alto contraste |

#### Colores Brillantes (8-15)

| Color | Hex | Uso Recomendado |
|-------|-----|-----------------|
| **color8** (Negro brillante) | `#4A6A72` | Fondos más oscuros, texto secundario |
| **color9** (Rojo brillante) | `#FF6B6B` | Errores críticos, alertas urgentes |
| **color10** (Verde brillante) | `#51CF66` | Confirmación brillante, éxito destacado |
| **color11** (Amarillo brillante) | `#FFD93D` | Advertencias brillantes, atención |
| **color12** (Azul brillante) | `#74C0FC` | Enlaces activos, acciones destacadas |
| **color13** (Magenta brillante) | `#D0BFFF` | Elementos especiales brillantes |
| **color14** (Cian brillante) | `#4ECDC4` | URLs activas, información destacada |
| **color15** (Blanco brillante) | `#FFFFFF` | Texto de máximo contraste, elementos críticos |

### Colores de Pestañas

| Estado | Foreground | Background | Uso |
|--------|------------|------------|-----|
| **Activa** | `#E0F7FA` | `#458588` | Pestaña/sección actual |
| **Inactiva** | `#B0D4E1` | `#3A5A62` | Pestañas/secciones no activas |

## Lógica de Asignación

### Principios de Diseño

1. **Contraste**: El texto siempre debe tener suficiente contraste con el fondo
   - Texto claro (`#E0F7FA`) sobre fondos oscuros (`#2A4A52`, `#3A5A62`)
   - Texto oscuro (`#1E3246`) sobre fondos claros (solo si es necesario)

2. **Jerarquía Visual**:
   - **Elementos activos**: `#458588` (teal medio)
   - **Elementos hover**: Versiones más claras del color base
   - **Elementos deshabilitados**: `#4A6A72` (gris oscuro)

3. **Semántica de Colores**:
   - **Rojo** (`#E67E80`, `#FF6B6B`): Errores, peligro, eliminar
   - **Verde** (`#7ED321`, `#51CF66`): Éxito, confirmación, positivo
   - **Amarillo** (`#F5B041`, `#FFD93D`): Advertencias, atención
   - **Azul** (`#5DA8D1`, `#74C0FC`): Información, enlaces, acciones primarias
   - **Cian/Turquesa** (`#4ECDC4`): URLs, información secundaria
   - **Magenta** (`#A78BFA`, `#D0BFFF`): Elementos especiales, destacados

### Transparencia

- **Waybar**: Usa transparencia con `rgba()` (opacidad 0.85-0.95)
- **Mako**: Usa formato `#RRGGBBAA` (últimos 2 dígitos para alpha)
- **Kitty**: Usa `background_opacity 0.85` en la configuración

## Estética Frutiger Aero

La estética Frutiger Aero se caracteriza por un diseño futurista inspirado en los años 2000, con elementos que evocan naturaleza, agua y tecnología. Los botones y elementos interactivos utilizan un estilo **glass** (vidrio) que les da una apariencia translúcida y moderna.

### Estilo Glass en Botones

Los botones con estilo glass tienen las siguientes características:

- **Transparencia**: Fondo semitransparente con `rgba(255, 255, 255, 0.3)` a `rgba(255, 255, 255, 0.5)`
- **Perspectiva 3D**: Efecto de profundidad que hace que los botones parezcan sobresalir ligeramente del fondo
- **Bordes brillantes**: Bordes blancos semitransparentes (`rgba(255, 255, 255, 0.9)`) que crean un efecto de resplandor
- **Sombras suaves**: `box-shadow` con valores bajos (`0 2px 8px rgba(173, 216, 230, 0.4)`) para dar profundidad
- **Gradientes sutiles**: Gradientes lineales que van de blanco translúcido a colores pastel para crear profundidad
- **Text-shadow**: Sombra de texto blanca (`0 1px 3px rgba(255, 255, 255, 0.9)`) para mejorar la legibilidad sobre fondos translúcidos

Este efecto de perspectiva se logra combinando:
- Bordes más claros en la parte superior
- Sombras en la parte inferior
- Gradientes que simulan iluminación desde arriba
- Transiciones suaves en estados hover que intensifican el efecto de elevación

## Aplicación a Nuevas Apps

### Tipos de Aplicaciones

#### 1. Aplicaciones con CSS (Waybar, Wofi, etc.)

```css
/* Fondo principal */
background: #2A4A52;

/* Texto principal */
color: #E0F7FA;

/* Elementos activos */
background: #458588;
color: #E0F7FA;

/* Hover */
background: rgba(69, 133, 136, 0.8);
```

#### 2. Aplicaciones con Configuración de Colores (Kitty, Alacritty, etc.)

```
background              #2A4A52
foreground              #E0F7FA
cursor                  #E0F7FA
cursor_text_color       #2A4A52

# Colores de la paleta
color0  #3A5A62
color1  #E67E80
color2  #7ED321
# ... etc
```

#### 3. Aplicaciones con Notificaciones (Mako, Dunst, etc.)

```
# Fondo normal
background-color=#2A4A52E6  # Con transparencia

# Texto
text-color=#E0F7FA

# Urgencia baja
[urgency=low]
background-color=#5DA8D1D9
text-color=#1E3246

# Urgencia normal
[urgency=normal]
background-color=#458588E6
text-color=#E0F7FA

# Urgencia crítica
[urgency=critical]
background-color=#FF6B6BD9
text-color=#FFFFFF
```

#### 4. Aplicaciones con Tema JSON/TOML

```json
{
  "background": "#2A4A52",
  "foreground": "#E0F7FA",
  "cursor": "#E0F7FA",
  "colors": {
    "0": "#3A5A62",
    "1": "#E67E80",
    "2": "#7ED321",
    // ... etc
  }
}
```

## Ejemplos por Tipo de Elemento

### Botones

- **Normal**: Fondo `#458588`, texto `#E0F7FA`
- **Hover**: Fondo más claro (`rgba(69, 133, 136, 0.9)`)
- **Activo**: Fondo `#4ECDC4`, texto `#2A4A52`
- **Deshabilitado**: Fondo `#3A5A62`, texto `#4A6A72`

### Campos de Entrada

- **Fondo**: `#3A5A62`
- **Borde**: `#458588`
- **Texto**: `#E0F7FA`
- **Placeholder**: `#4A6A72`
- **Focus**: Borde `#4ECDC4`

### Barras de Progreso

- **Fondo**: `#3A5A62`
- **Progreso**: `#4ECDC4` o `#51CF66`
- **Texto**: `#E0F7FA`

### Alertas/Mensajes

- **Info**: Fondo `#5DA8D1`, texto `#E0F7FA`
- **Éxito**: Fondo `#7ED321`, texto `#2A4A52`
- **Advertencia**: Fondo `#F5B041`, texto `#2A4A52`
- **Error**: Fondo `#E67E80`, texto `#E0F7FA`

## Referencias

- **Kitty Theme**: `editions/kitty/themes/current-theme.conf`
- **Waybar Style**: `editions/waybar/style.css`
- **Mako Config**: `editions/mako/config`

## Conversión de Formatos

### Hex a RGB

```python
# #2A4A52 → rgb(42, 74, 82)
# #E0F7FA → rgb(224, 247, 250)
```

### Hex a RGBA (para CSS)

```css
/* #2A4A52 con opacidad 0.85 */
background: rgba(42, 74, 82, 0.85);
```

### Hex a RRGGBBAA (para Mako)

```
#2A4A52 con opacidad 0.85 (217 en hex = 0xD9)
→ #2A4A52D9
```

## Checklist para Nueva App

- [ ] Usar `#2A4A52` como fondo principal
- [ ] Usar `#E0F7FA` para texto principal
- [ ] Usar `#458588` para elementos activos/seleccionados
- [ ] Aplicar colores semánticos (rojo=error, verde=éxito, etc.)
- [ ] Mantener contraste adecuado (mínimo 4.5:1)
- [ ] Usar transparencia cuando sea apropiado (0.85-0.95)
- [ ] Probar en modo claro y oscuro si aplica
- [ ] Verificar accesibilidad de colores


