import React, { Component } from 'react'

export const VARIABLE_ENTITY_TYPE = 'VARIABLE'

function variableStrategy(contentBlock, callback, contentState) {
  contentBlock.findEntityRanges(
    (character) => {
      const entityKey = character.getEntity()
      if (entityKey === null) {
        return false
      }

      return contentState.getEntity(entityKey).getType() === VARIABLE_ENTITY_TYPE;
    },
    callback
  )
}

class VariableSpan extends Component {
  render() {
    const { offsetkey, children, contentState, entityKey } = this.props

    const entity = contentState.getEntity(entityKey)
    const variableName = entity.getData().name
    const cls = `${variableName}-variable`

    return (
      <span data-offset-key={offsetkey} className={cls}>{children}</span>
    )
  }
}

export function createVariablePlugin(config = {}) {
  return {
    decorators: [
      {
        strategy: variableStrategy,
        component: VariableSpan,
      }
    ]
  }
}
